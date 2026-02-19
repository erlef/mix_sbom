defmodule Version.Requirement.Vers do
  @moduledoc """
  Support for the Vers specification for version ranges.

  This module provides utilities for converting between Elixir version requirements
  and the universal Vers specification format, enabling interoperability across
  different package management systems.

  ## Vers Specification

  The Vers specification defines a universal format for version ranges that works
  across different package managers and programming languages.

  ## External References

  - [Vers Specification](https://github.com/package-url/vers-spec/blob/main/VERSION-RANGE-SPEC.md)
  - [Semantic Versioning](https://semver.org/)
  """

  # TODO: Move into Elixir Core or remove private API access

  alias Version.Requirement.Multirange

  @type type() :: String.t()

  @doc """
  Converts version requirements or requirement strings to vers specification format.

  Accepts `Version.Requirement` structs or string requirements and converts them
  to the universal vers specification format.

  ## Parameters

  - `input` - A `Version.Requirement` struct or string requirement
  - `type` - The package type (defaults to "elixir")

  ## Examples

      iex> Version.Requirement.Vers.to_vers("~> 1.2.3")
      {:ok, "vers:elixir/>=1.2.3|<1.3.0"}

      iex> Version.Requirement.Vers.to_vers(">= 1.0.0 and < 2.0.0")
      {:ok, "vers:elixir/>=1.0.0|<2.0.0"}

      iex> Version.Requirement.Vers.to_vers("== 1.0.0", "npm")
      {:ok, "vers:npm/1.0.0"}

      iex> req = Version.parse_requirement!("~> 1.2.3")
      ...> Version.Requirement.Vers.to_vers(req)
      {:ok, "vers:elixir/>=1.2.3|<1.3.0"}

      iex> Version.Requirement.Vers.to_vers("invalid")
      :error

  """
  @spec to_vers(Version.Requirement.t() | String.t(), type()) ::
          {:ok, String.t()} | :error
  def to_vers(input, type \\ "elixir")

  def to_vers(input, type) when is_binary(input) or is_struct(input, Version.Requirement) do
    with {:ok, multi_range} <- Multirange.to_multi_range(input) do
      to_vers_private(multi_range, type)
    end
  end

  @doc """
  Parses vers specification strings to Elixir `Version.Requirement` structs.

  Accepts vers specification strings and returns both the parsed requirement
  and the extracted type information.

  ## Examples

      iex> {:ok, {req, "elixir"}} = Version.Requirement.Vers.from_vers("vers:elixir/>=1.0.0")
      ...> to_string(req)
      ">= 1.0.0"

      iex> Version.Requirement.Vers.from_vers("vers:npm/*")
      {:ok, {:any, "npm"}}

      iex> {:ok, {req, "elixir"}} = Version.Requirement.Vers.from_vers("vers:elixir/>=1.0.0|<2.0.0")
      ...> to_string(req)
      "~> 1.0"

      iex> Version.Requirement.Vers.from_vers("invalid")
      :error

  """
  @spec from_vers(String.t()) :: {:ok, {Version.Requirement.t() | :any, type()}} | :error
  def from_vers(vers_string) do
    with {:ok, {multi_range, type}} <- from_vers_to_multi_range(vers_string),
         {:ok, requirement} <- Multirange.to_requirement(multi_range) do
      {:ok, {requirement, type}}
    end
  end

  @spec to_vers_private(Multirange.multi_range(), String.t()) :: {:ok, String.t()} | :error
  defp to_vers_private([], _type), do: :error
  defp to_vers_private([{:min, :max}], type), do: {:ok, "vers:#{type}/*"}

  defp to_vers_private([_range | _rest] = multi_range, type) do
    constraints =
      multi_range
      |> Enum.flat_map(&range_to_constraints/1)
      |> Enum.join("|")

    {:ok, "vers:#{type}/#{constraints}"}
  end

  @spec from_vers_to_multi_range(String.t()) ::
          {:ok, {Multirange.multi_range(), String.t()}} | :error
  defp from_vers_to_multi_range(vers_string) do
    with {:ok, {type, constraints_string}} <- parse_vers_format(vers_string),
         {:ok, constraints} <- parse_constraints(constraints_string),
         {:ok, multi_range} <- combine_constraints(constraints) do
      {:ok, {multi_range, type}}
    end
  end

  @spec range_to_constraints(Multirange.range()) :: [String.t()]
  defp range_to_constraints({{:including, version}, {:including, version}}) do
    [matchable_to_string(version)]
  end

  defp range_to_constraints({:min, {:including, version}}) do
    ["<=#{matchable_to_string(version)}"]
  end

  defp range_to_constraints({:min, {:excluding, version}}) do
    ["<#{matchable_to_string(version)}"]
  end

  defp range_to_constraints({{:including, version}, :max}) do
    [">=#{matchable_to_string(version)}"]
  end

  defp range_to_constraints({{:excluding, version}, :max}) do
    [">#{matchable_to_string(version)}"]
  end

  defp range_to_constraints({{:including, lower_v}, {:including, upper_v}}) do
    [">=#{matchable_to_string(lower_v)}", "<=#{matchable_to_string(upper_v)}"]
  end

  defp range_to_constraints({{:including, lower_v}, {:excluding, upper_v}}) do
    [">=#{matchable_to_string(lower_v)}", "<#{matchable_to_string(upper_v)}"]
  end

  defp range_to_constraints({{:excluding, lower_v}, {:including, upper_v}}) do
    [">#{matchable_to_string(lower_v)}", "<=#{matchable_to_string(upper_v)}"]
  end

  defp range_to_constraints({{:excluding, lower_v}, {:excluding, upper_v}}) do
    [">#{matchable_to_string(lower_v)}", "<#{matchable_to_string(upper_v)}"]
  end

  # TODO: Should go into Version.Requirement
  # credo:disable-for-lines:6 Credo.Check.Design.DuplicatedCode
  @spec matchable_to_string(Multirange.matchable()) :: String.t()
  defp matchable_to_string({major, minor, patch, pre, build}) do
    base = "#{major}.#{minor}.#{patch || 0}"
    base = if pre && pre != [], do: "#{base}-#{Enum.join(pre, ".")}", else: base
    if build && build != [], do: "#{base}+#{Enum.join(build, ".")}", else: base
  end

  @spec parse_vers_format(String.t()) :: {:ok, {String.t(), String.t()}} | :error
  defp parse_vers_format("vers:" <> rest) do
    case String.split(rest, "/", parts: 2) do
      [type, constraints_string] -> {:ok, {type, constraints_string}}
      _invalid -> :error
    end
  end

  defp parse_vers_format(_invalid), do: :error

  @spec parse_constraints(String.t()) :: {:ok, [String.t()]} | :error
  defp parse_constraints(""), do: :error
  defp parse_constraints("*"), do: {:ok, ["*"]}

  defp parse_constraints(constraints_string) do
    constraints = String.split(constraints_string, "|")

    if Enum.all?(constraints, &valid_constraint?/1) do
      {:ok, constraints}
    else
      :error
    end
  end

  @spec valid_constraint?(String.t()) :: boolean()
  defp valid_constraint?(constraint) do
    constraint =~ ~r/^(!=|>=|>|<=|<)?.+/ or constraint == "*"
  end

  @spec parse_version_string(String.t()) :: {:ok, Multirange.matchable()} | :error
  defp parse_version_string(version) do
    with {:ok, version} <- Version.parse(version) do
      build =
        case List.wrap(version.build) do
          [] -> []
          [build] -> String.split(build, ".")
          [_first | _rest] = builds -> builds
        end

      {:ok, {version.major, version.minor, version.patch, version.pre, build}}
    end
  end

  @spec combine_constraints([String.t()]) :: {:ok, Multirange.multi_range()} | :error
  defp combine_constraints(constraints) do
    with {:ok, parsed_constraints} <- parse_all_constraints(constraints) do
      parsed_constraints
      |> then(&[:min | &1])
      |> Enum.chunk_every(3, 1, [:max])
      |> Enum.map(fn [lower, constraint, upper] ->
        bounding_range =
          case {lower, upper} do
            {:min, :max} -> [{:min, :max}]
            {:min, {_op, version}} -> [{:min, {:excluding, version}}]
            {{_op, version}, :max} -> [{{:excluding, version}, :max}]
            {{_op1, lower_v}, {_op2, upper_v}} -> [{{:excluding, lower_v}, {:excluding, upper_v}}]
          end

        constrains_multirange =
          case constraint do
            :* -> [{:min, :max}]
            {:!=, version} -> [{:min, {:excluding, version}}, {{:excluding, version}, :max}]
            {:<, version} -> [{:min, {:excluding, version}}]
            {:<=, version} -> [{:min, {:including, version}}]
            {:>, version} -> [{{:excluding, version}, :max}]
            {:>=, version} -> [{{:including, version}, :max}]
            {:==, version} -> [{{:including, version}, {:including, version}}]
          end

        Multirange.intersect(constrains_multirange, bounding_range)
      end)
      |> Enum.reduce([], &Multirange.union/2)
      |> then(&{:ok, &1})
    end
  end

  @spec parse_all_constraints([String.t()]) ::
          {:ok, [atom() | {atom(), Multirange.matchable()}]} | :error
  defp parse_all_constraints(constraints) do
    constraints
    |> Enum.reduce_while({:ok, []}, fn constraint, {:ok, acc} ->
      case parse_constraint(constraint) do
        {:ok, parsed} -> {:cont, {:ok, [parsed | acc]}}
        :error -> {:halt, :error}
      end
    end)
    |> case do
      {:ok, results} -> {:ok, Enum.reverse(results)}
      :error -> :error
    end
  end

  @spec parse_constraint(String.t()) :: {:ok, atom() | {atom(), Multirange.matchable()}} | :error
  defp parse_constraint("*"), do: {:ok, :*}
  defp parse_constraint("!=" <> version), do: with_parsed_version(version, &{:!=, &1})
  defp parse_constraint("<=" <> version), do: with_parsed_version(version, &{:<=, &1})
  defp parse_constraint(">=" <> version), do: with_parsed_version(version, &{:>=, &1})
  defp parse_constraint("<" <> version), do: with_parsed_version(version, &{:<, &1})
  defp parse_constraint(">" <> version), do: with_parsed_version(version, &{:>, &1})
  defp parse_constraint(version), do: with_parsed_version(version, &{:==, &1})

  @spec with_parsed_version(String.t(), (Multirange.matchable() -> term())) ::
          {:ok, term()} | :error
  defp with_parsed_version(version_string, fun) do
    with {:ok, version} <- parse_version_string(version_string) do
      {:ok, fun.(version)}
    end
  end
end
