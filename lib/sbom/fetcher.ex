# SPDX-License-Identifier: BSD-3-Clause
# SPDX-FileCopyrightText: 2025 Erlang Ecosystem Foundation

defmodule SBoM.Fetcher do
  @moduledoc false

  # Defines the behaviour for manifest fetchers and provides an entry point to
  # collect dependency data from multiple sources.
  #
  # The built-in fetchers include:
  #
  #   * `SBoM.Fetcher.MixFile` — parses `mix.exs`
  #   * `SBoM.Fetcher.MixLock` — parses `mix.lock`
  #   * `SBoM.Fetcher.MixRuntime` — inspects runtime dependency
  #     graph

  alias SBoM.SCM

  @type app_name() :: atom()
  @type mix_dep() :: {app_name(), requirement :: String.t(), opts :: Keyword.t()}

  @type dependency() :: %{
          optional(:scm) => module(),
          optional(:version) => String.t(),
          optional(:version_requirement) => String.t(),
          optional(:mix_dep) => mix_dep(),
          optional(:mix_lock) => SCM.lock(),
          optional(:runtime) => boolean(),
          optional(:optional) => boolean(),
          optional(:targets) => :* | [atom()],
          optional(:only) => :* | [atom()],
          optional(:dependencies) => [app_name()],
          optional(:mix_config) => Keyword.t(),
          optional(:package_url) => Purl.t(),
          optional(:licenses) => [String.t()],
          optional(:root) => boolean(),
          optional(:source_url) => String.t(),
          optional(:links) => SBoM.Fetcher.Links.t()
        }

  @doc """
  Fetches dependencies from a specific source.

  Implementers must return a map of app names to raw dependency data, or `nil`
  if no data is available.

  This callback is used by the main `SBoM.Fetcher.fetch/0`
  function to gather and merge data from multiple sources like `mix.exs`,
  `mix.lock`, or the compiled dependency graph.

  ## Example return value

      %{
        my_dep: %{
          scm: Mix.SCM.Hex,
          version: "0.1.0",
          optional: true,
          runtime: false,
          targets: [:host],
          only: [:dev, :test]
        }
      }

  Returning `nil` signals that no data could be fetched by the implementation.
  """
  @callback fetch() :: %{optional(app_name()) => dependency()} | nil

  @manifest_fetchers [__MODULE__.MixFile, __MODULE__.MixLock, __MODULE__.MixRuntime]

  @static_deps %{
    elixir: %{
      scm: SBoM.SCM.System,
      mix_dep: {:elixir, nil, []},
      optional: false,
      runtime: true,
      targets: :*,
      only: :*
    },
    stdlib: %{
      scm: SBoM.SCM.System,
      mix_dep: {:stdlib, nil, []},
      optional: false,
      runtime: true,
      targets: :*,
      only: :*
    },
    kernel: %{
      scm: SBoM.SCM.System,
      mix_dep: {:kernel, nil, []},
      optional: false,
      runtime: true,
      targets: :*,
      only: :*
    }
  }

  @doc """
  Fetches and merges dependencies from all registered fetchers.

  Returns a map of stringified app names to structured `Dependency` records,
  ready to be submitted as a manifest.

  ## Examples

      iex> %{
      ...>   # SBoM.Submission.Manifest.Dependency
      ...>   "burrito" => %{
      ...>     package_url: %Purl{type: "hex", name: "burrito"},
      ...>     optional: false,
      ...>     runtime: true,
      ...>     targets: [:standalone],
      ...>     only: :*,
      ...>     dependencies: _dependencies
      ...>   }
      ...> } = SBoM.Fetcher.fetch()

  Note: This test assumes an Elixir project that is currently loaded.
  """
  @spec fetch() :: %{String.t() => dependency()} | nil
  def fetch do
    @manifest_fetchers
    |> Enum.map(& &1.fetch())
    |> Enum.reduce(nil, fn
      nil, acc ->
        acc

      dependencies, acc ->
        Map.merge(acc || %{}, dependencies, &merge/3)
    end)
    |> case do
      nil ->
        nil

      %{} = deps ->
        deps = Map.merge(deps, @static_deps, &merge/3)

        transform_all(deps)
    end
  end

  @spec merge(app_name(), left :: dependency(), right :: dependency()) :: dependency()
  defp merge(_app, left, right), do: Map.merge(left, right, &merge_property/3)

  @spec merge_property(key :: atom(), left :: value, right :: value) :: value when value: term()
  defp merge_property(key, left, right)
  defp merge_property(_key, value, value), do: value
  defp merge_property(:dependencies, left, right), do: Enum.uniq(left ++ right)
  defp merge_property(:runtime, left, right), do: left or right
  defp merge_property(:optional, left, right), do: left and right
  defp merge_property(:targets, :*, _right), do: :*
  defp merge_property(:targets, _left, :*), do: :*
  defp merge_property(:targets, left, right), do: Enum.uniq(left ++ right)
  defp merge_property(:only, :*, _right), do: :*
  defp merge_property(:only, _left, :*), do: :*
  defp merge_property(:only, left, right), do: Enum.uniq(left ++ right)
  defp merge_property(_key, _left, right), do: right

  @doc false
  @spec transform_all(dependencies :: %{app_name() => dependency()}) :: %{
          String.t() => dependency()
        }
  def transform_all(dependencies) do
    dependencies =
      Map.new(dependencies, fn {app, dependency} ->
        {app, transform(app, drop_empty(dependency))}
      end)

    Map.new(dependencies, fn {app, dependency} ->
      dependency =
        dependency
        |> update_in(
          [Access.key!(:dependencies), Access.all()],
          &get_in(dependencies, [Access.key(&1), Access.key!(:package_url)])
        )
        |> update_in([Access.key!(:dependencies)], fn list -> Enum.reject(list, &is_nil/1) end)

      {Atom.to_string(app), dependency}
    end)
  end

  @spec transform(app_name(), dependency()) :: dependency()
  defp transform(app, dependency) do
    sub_dependencies =
      Enum.uniq((dependency[:dependencies] || []) ++ lock_dependencies(dependency))

    # Fetch package metadata from SCM if available
    package_metadata = get_package_metadata(app, dependency)

    # Merge package metadata with dependency (prefer existing values, fill gaps)
    dependency =
      Map.merge(package_metadata, dependency, &merge_property/3)

    purl = package_url(dependency, app)

    purl =
      case dependency[:source_url] do
        nil -> purl
        url -> %{purl | qualifiers: Map.put_new(purl.qualifiers, "vcs_url", url)}
      end

    Map.merge(
      dependency,
      %{
        package_url: purl,
        dependencies: sub_dependencies
      }
    )
  end

  @spec package_url(dependency(), app_name()) :: Purl.t()
  defp package_url(dependency, app)

  defp package_url(%{scm: scm, mix_lock: mix_lock} = dependency, app) do
    case SCM.implementation(scm) do
      nil ->
        dependency |> Map.drop(~w[mix_lock]a) |> package_url(app)

      impl ->
        if function_exported?(impl, :mix_lock_to_purl, 2) do
          impl.mix_lock_to_purl(app, mix_lock)
        else
          dependency |> Map.drop(~w[mix_lock]a) |> package_url(app)
        end
    end
  end

  defp package_url(%{scm: scm, mix_dep: mix_dep} = dependency, app) do
    case SCM.implementation(scm) do
      nil -> dependency |> Map.drop(~w[mix_dep]a) |> package_url(app)
      impl -> impl.mix_dep_to_purl(mix_dep, dependency[:version])
    end
  end

  defp package_url(%{scm: SBoM.SCM.System} = dependency, app) do
    SBoM.SCM.SBoM.SCM.System.mix_dep_to_purl({app, "*", []}, dependency[:version])
  end

  defp package_url(dependency, app) do
    fallback =
      Purl.new!(%Purl{
        type: "generic",
        name: Atom.to_string(app),
        version: dependency[:version]
      })

    case dependency[:source_url] do
      nil ->
        fallback

      url ->
        case Purl.from_resource_uri(url, dependency[:version]) do
          {:ok, purl} -> purl
          :error -> fallback
        end
    end
  end

  @spec get_package_metadata(app_name(), dependency()) :: dependency()
  defp get_package_metadata(app, dependency) do
    with scm when not is_nil(scm) <- dependency[:scm],
         impl when not is_nil(impl) <- SCM.implementation(scm),
         true <- function_exported?(impl, :enhance_metadata, 2) do
      try do
        impl.enhance_metadata(app, dependency)
      rescue
        _error -> %{}
      catch
        _reason -> %{}
      end
    else
      _otherwise -> %{}
    end
  end

  @spec lock_dependencies(dependency()) :: [app_name()]
  defp lock_dependencies(dependency)

  defp lock_dependencies(%{scm: scm, mix_lock: mix_lock} = dependency) do
    case SCM.implementation(scm) do
      nil ->
        dependency |> Map.drop(~w[scm]a) |> lock_dependencies()

      impl ->
        if function_exported?(impl, :mix_lock_deps, 1) do
          impl.mix_lock_deps(mix_lock)
        else
          dependency |> Map.drop(~w[scm]a) |> lock_dependencies()
        end
    end
  end

  defp lock_dependencies(_dependency), do: []

  @doc false
  @spec drop_empty(map :: %{key => value | nil}) :: %{key => value}
        when key: term(), value: term()
  def drop_empty(map), do: map |> Enum.reject(fn {_key, value} -> value in [nil, ""] end) |> Map.new()
end
