defmodule Version.Requirement.Multirange do
  @moduledoc false

  # TODO: Move into Elixir Core or remove private API access

  # Not exported
  # @typep matchable :: Version.Requirement.matchable()
  @type matchable() ::
          {major :: Version.major(), minor :: Version.minor(), patch :: Version.patch() | nil, pre :: Version.pre() | nil,
           build :: [Version.build()] | nil}
  @type operator() :: :== | :!= | :~> | :> | :>= | :< | :<=

  @type inclusion() :: :including | :excluding
  @type bound() :: :min | :max | {inclusion :: inclusion(), version :: matchable()}
  @type range() :: {lower :: bound(), upper :: bound()}
  @type multi_range() :: [range()]

  @spec to_multi_range(String.t() | Version.Requirement.t()) :: {:ok, multi_range()} | :error
  def to_multi_range(requirement)

  def to_multi_range(requirement) when is_binary(requirement) do
    with {:ok, requirement} <- Version.parse_requirement(requirement) do
      to_multi_range(requirement)
    end
  end

  def to_multi_range(%Version.Requirement{lexed: lexed}) do
    [:or | lexed]
    |> Enum.chunk_every(3)
    |> Enum.reduce([], fn
      [:and, operator, req], acc ->
        condition_multi_range = condition_to_multi_range(operator, req)
        intersect(acc, condition_multi_range)

      [:or, operator, req], acc ->
        condition_multi_range = condition_to_multi_range(operator, req)
        union(acc, condition_multi_range)

      _incomplete_chunk, acc ->
        acc
    end)
    |> then(&{:ok, &1})
  end

  @spec intersect(multi_range(), multi_range()) :: multi_range()
  def intersect(left, right)
  def intersect([], _right), do: []
  def intersect(_left, []), do: []

  def intersect(left, right) do
    for_result =
      for range1 <- left,
          range2 <- right,
          intersected = intersect_range(range1, range2),
          intersected != nil do
        intersected
      end

    union(for_result, [])
  end

  @spec union(multi_range(), multi_range()) :: multi_range()
  def union(left, right) do
    (left ++ right)
    |> Enum.sort(&compare_ranges/2)
    |> merge_overlapping_ranges([])
  end

  @spec to_requirement(multi_range()) :: {:ok, Version.Requirement.t() | :any} | :error
  def to_requirement([]), do: :error
  def to_requirement([{:min, :max}]), do: {:ok, :any}

  def to_requirement(multi_range) do
    requirement_string = multi_range_to_requirement_string(multi_range)
    Version.parse_requirement(requirement_string)
  end

  # TODO: Should go into Version.Requirement
  # credo:disable-for-lines:6 Credo.Check.Design.DuplicatedCode
  @spec matchable_to_string(matchable()) :: String.t()
  defp matchable_to_string({major, minor, patch, pre, build}) do
    base = "#{major}.#{minor}.#{patch || 0}"
    base = if pre && pre != [], do: "#{base}-#{Enum.join(pre, ".")}", else: base
    if build && build != [], do: "#{base}+#{Enum.join(build, ".")}", else: base
  end

  @spec multi_range_to_requirement_string(multi_range()) :: String.t()
  defp multi_range_to_requirement_string(multi_range) do
    Enum.map_join(multi_range, " or ", &range_to_requirement_constraints/1)
  end

  @spec range_to_requirement_constraints(range()) :: String.t()
  defp range_to_requirement_constraints({{:including, version}, {:including, version}}) do
    "== #{matchable_to_string(version)}"
  end

  defp range_to_requirement_constraints(
         {{:including, {maj, min, patch, pre, build}}, {:excluding, {maj, next_min, 0, [], []}}}
       )
       when next_min == min + 1 and patch != 0 do
    "~> #{matchable_to_string({maj, min, patch, pre, build})}"
  end

  defp range_to_requirement_constraints({{:including, {maj, min, 0, [], []}}, {:excluding, {next_maj, 0, 0, [], []}}})
       when next_maj == maj + 1 do
    "~> #{maj}.#{min}"
  end

  defp range_to_requirement_constraints({:min, {:including, version}}) do
    "<= #{matchable_to_string(version)}"
  end

  defp range_to_requirement_constraints({:min, {:excluding, version}}) do
    "< #{matchable_to_string(version)}"
  end

  defp range_to_requirement_constraints({{:including, version}, :max}) do
    ">= #{matchable_to_string(version)}"
  end

  defp range_to_requirement_constraints({{:excluding, version}, :max}) do
    "> #{matchable_to_string(version)}"
  end

  defp range_to_requirement_constraints({{:including, lower_v}, {:including, upper_v}}) do
    ">= #{matchable_to_string(lower_v)} and <= #{matchable_to_string(upper_v)}"
  end

  defp range_to_requirement_constraints({{:including, lower_v}, {:excluding, upper_v}}) do
    ">= #{matchable_to_string(lower_v)} and < #{matchable_to_string(upper_v)}"
  end

  defp range_to_requirement_constraints({{:excluding, lower_v}, {:including, upper_v}}) do
    "> #{matchable_to_string(lower_v)} and <= #{matchable_to_string(upper_v)}"
  end

  defp range_to_requirement_constraints({{:excluding, lower_v}, {:excluding, upper_v}}) do
    "> #{matchable_to_string(lower_v)} and < #{matchable_to_string(upper_v)}"
  end

  @spec condition_to_multi_range(operator(), matchable()) :: multi_range()
  defp condition_to_multi_range(operator, req)
  defp condition_to_multi_range(:==, req), do: [{{:including, req}, {:including, req}}]

  defp condition_to_multi_range(:!=, req), do: [{:min, {:excluding, req}}, {{:excluding, req}, :max}]

  defp condition_to_multi_range(:~>, {major, minor, nil, pre, _build}),
    do: [{{:including, {major, minor, 0, pre, nil}}, {:excluding, {major + 1, 0, 0, [], nil}}}]

  defp condition_to_multi_range(:~>, {major, minor, patch, pre, build}),
    do: [{{:including, {major, minor, patch, pre, build}}, {:excluding, {major, minor + 1, 0, [], nil}}}]

  defp condition_to_multi_range(:>, req), do: [{{:excluding, req}, :max}]
  defp condition_to_multi_range(:>=, req), do: [{{:including, req}, :max}]
  defp condition_to_multi_range(:<, req), do: [{:min, {:excluding, req}}]
  defp condition_to_multi_range(:<=, req), do: [{:min, {:including, req}}]

  @spec intersect_range(range(), range()) :: range() | nil
  defp intersect_range({lower_left, upper_left}, {lower_right, upper_right}) do
    intersection_lower = max_bound_for_intersection(lower_left, lower_right)
    intersection_upper = min_bound_for_intersection(upper_left, upper_right)

    if bounds_valid_range?(intersection_lower, intersection_upper) do
      {intersection_lower, intersection_upper}
    end
  end

  @spec max_bound_for_intersection(bound(), bound()) :: bound()
  defp max_bound_for_intersection(bound_left, bound_right) do
    case compare_bounds(bound_left, bound_right, :lower) do
      :lt -> bound_right
      :eq -> prefer_more_specific_bound(bound_left, bound_right)
      :gt -> bound_left
    end
  end

  @spec min_bound_for_intersection(bound(), bound()) :: bound()
  defp min_bound_for_intersection(bound_left, bound_right) do
    case compare_bounds(bound_left, bound_right, :upper) do
      :lt -> bound_left
      :eq -> prefer_more_specific_bound(bound_left, bound_right)
      :gt -> bound_right
    end
  end

  @spec prefer_more_specific_bound(bound(), bound()) :: bound()
  defp prefer_more_specific_bound(:min, bound_right), do: bound_right
  defp prefer_more_specific_bound(bound_left, :min), do: bound_left
  defp prefer_more_specific_bound(:max, bound_right), do: bound_right
  defp prefer_more_specific_bound(bound_left, :max), do: bound_left

  defp prefer_more_specific_bound(
         {inc_left, {maj_left, min_left, patch_left, pre_left, build_left}},
         {inc_right, {maj_right, min_right, patch_right, pre_right, build_right}}
       ) do
    # Prefer the bound with build metadata when versions are equal
    cond do
      length(build_left) > length(build_right) ->
        {inc_left, {maj_left, min_left, patch_left, pre_left, build_left}}

      length(build_right) > length(build_left) ->
        {inc_right, {maj_right, min_right, patch_right, pre_right, build_right}}

      # Default to first when equal
      true ->
        {inc_left, {maj_left, min_left, patch_left, pre_left, build_left}}
    end
  end

  @spec bounds_valid_range?(bound(), bound()) :: boolean()
  defp bounds_valid_range?(lower, upper) do
    case {compare_versions_for_bounds(lower, upper), lower, upper} do
      {:lt, _lower, _upper} -> true
      {:gt, _lower, _upper} -> false
      {:eq, {:including, _version}, {:excluding, _version2}} -> false
      {:eq, {:excluding, _version}, {:including, _version2}} -> false
      {:eq, {:excluding, _version}, {:excluding, _version2}} -> false
      {:eq, _lower, _upper} -> true
    end
  end

  @spec compare_versions_for_bounds(bound(), bound()) :: :lt | :eq | :gt
  defp compare_versions_for_bounds(:min, :min), do: :eq
  defp compare_versions_for_bounds(:min, _right), do: :lt
  defp compare_versions_for_bounds(_left, :min), do: :gt
  defp compare_versions_for_bounds(:max, :max), do: :eq
  defp compare_versions_for_bounds(:max, _right), do: :gt
  defp compare_versions_for_bounds(_left, :max), do: :lt

  defp compare_versions_for_bounds({_inc_left, version_left}, {_inc_right, version_right}) do
    compare_versions(version_left, version_right)
  end

  @spec compare_ranges(range(), range()) :: boolean()
  defp compare_ranges(left, right) do
    case compare_bounds(elem(left, 0), elem(right, 0), :lower) do
      :lt -> true
      :eq -> true
      :gt -> false
    end
  end

  @spec compare_bounds(bound(), bound(), :lower | :upper) :: :lt | :eq | :gt
  defp compare_bounds(:min, :min, _direction), do: :eq
  defp compare_bounds(:min, _right, _direction), do: :lt
  defp compare_bounds(_left, :min, _direction), do: :gt
  defp compare_bounds(:max, :max, _direction), do: :eq
  defp compare_bounds(:max, _right, _direction), do: :gt
  defp compare_bounds(_left, :max, _direction), do: :lt

  defp compare_bounds({inclusion_left, version_left}, {inclusion_right, version_right}, direction) do
    case compare_versions(version_left, version_right) do
      :lt -> :lt
      :gt -> :gt
      :eq -> compare_inclusions(inclusion_left, inclusion_right, direction)
    end
  end

  @spec compare_inclusions(:including | :excluding, :including | :excluding, :lower | :upper) ::
          :lt | :eq | :gt
  defp compare_inclusions(:including, :including, _direction), do: :eq
  defp compare_inclusions(:excluding, :excluding, _direction), do: :eq
  defp compare_inclusions(:including, :excluding, :lower), do: :lt
  defp compare_inclusions(:excluding, :including, :lower), do: :gt
  defp compare_inclusions(:including, :excluding, :upper), do: :gt
  defp compare_inclusions(:excluding, :including, :upper), do: :lt

  @spec compare_versions(matchable(), matchable()) :: :lt | :eq | :gt
  defp compare_versions(
         {maj_left, min_left, patch_left, pre_left, _build_left},
         {maj_right, min_right, patch_right, pre_right, _build_right}
       ) do
    with :eq <- compare_numbers(maj_left, maj_right),
         :eq <- compare_numbers(min_left, min_right),
         :eq <- compare_numbers(patch_left || 0, patch_right || 0) do
      compare_prerelease(pre_left, pre_right)
    end
  end

  @spec compare_numbers(integer(), integer()) :: :lt | :eq | :gt
  defp compare_numbers(left, right) when left < right, do: :lt
  defp compare_numbers(left, right) when left > right, do: :gt
  defp compare_numbers(_left, _right), do: :eq

  @spec compare_prerelease(list(), list()) :: :lt | :eq | :gt
  defp compare_prerelease(pre_left, pre_right) do
    cond do
      pre_left == [] and pre_right != [] -> :gt
      pre_left != [] and pre_right == [] -> :lt
      pre_left > pre_right -> :gt
      pre_left < pre_right -> :lt
      true -> :eq
    end
  end

  @spec merge_overlapping_ranges([range()], [range()]) :: multi_range()
  defp merge_overlapping_ranges([], acc), do: Enum.reverse(acc)
  defp merge_overlapping_ranges([range], acc), do: Enum.reverse([range | acc])

  defp merge_overlapping_ranges([range_left, range_right | rest], acc) do
    if ranges_overlap_or_adjacent?(range_left, range_right) do
      merged = merge_ranges(range_left, range_right)
      merge_overlapping_ranges([merged | rest], acc)
    else
      merge_overlapping_ranges([range_right | rest], [range_left | acc])
    end
  end

  @spec ranges_overlap_or_adjacent?(range(), range()) :: boolean()
  defp ranges_overlap_or_adjacent?({_lower_left, upper_left}, {lower_right, _upper_right}) do
    # Don't merge ranges that both exclude the same version (represents != pattern)
    case {upper_left, lower_right} do
      {{:excluding, version}, {:excluding, version}} -> false
      _other -> compare_bounds(upper_left, lower_right, :upper) != :lt
    end
  end

  @spec merge_ranges(range(), range()) :: range()
  defp merge_ranges({lower_left, upper_left}, {lower_right, upper_right}) do
    {min_bound(lower_left, lower_right), max_bound(upper_left, upper_right)}
  end

  @spec min_bound(bound(), bound()) :: bound()
  defp min_bound(bound_left, bound_right) do
    case compare_bounds(bound_left, bound_right, :lower) do
      :lt -> bound_left
      :eq -> bound_left
      :gt -> bound_right
    end
  end

  @spec max_bound(bound(), bound()) :: bound()
  defp max_bound(bound_left, bound_right) do
    case compare_bounds(bound_left, bound_right, :upper) do
      :lt -> bound_right
      :eq -> bound_left
      :gt -> bound_left
    end
  end
end
