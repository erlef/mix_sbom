# SPDX-License-Identifier: BSD-3-Clause
# SPDX-FileCopyrightText: 2025 Erlang Ecosystem Foundation

defmodule SBoM.Fetcher.MixFile do
  @moduledoc """
  A `SBoM.Fetcher` implementation that extracts dependencies
  from the current project's `mix.exs` file.

  This module is responsible for reading and normalizing direct dependencies
  defined in the project configuration, returning them in a standard format
  expected by the submission tool.
  """

  @behaviour SBoM.Fetcher

  alias SBoM.Fetcher
  alias SBoM.Fetcher.Links

  @doc """
  Fetches and normalizes the direct dependencies defined in the `mix.exs` file.

  This implementation reads the project configuration via
  `Mix.Project.config()[:deps]` and normalizes each dependency entry.

  ## Examples

      iex> %{
      ...>   burrito: %{
      ...>     scm: Hex.SCM,
      ...>     mix_dep: _dep,
      ...>     optional: false,
      ...>     runtime: true,
      ...>     targets: [:standalone],
      ...>     only: :*
      ...>   }
      ...> } =
      ...>   SBoM.Fetcher.MixFile.fetch()

  Note: This test assumes an Elixir project that is currently loaded with a
  `mix.exs` file in place.
  """
  @impl Fetcher
  def fetch do
    app_config = get_application_config()

    deps =
      [
        Mix.Project.config()[:deps] || [],
        [{:elixir, Mix.Project.config()[:elixir], []}],
        Enum.map(app_config[:applications] || [], &{&1, []}),
        Enum.map(app_config[:extra_applications] || [], &{&1, []}),
        Enum.map(app_config[:included_applications] || [], &{&1, included: true})
      ]
      |> Enum.concat()
      |> Enum.uniq_by(&elem(&1, 0))
      |> Map.new(&normalize_dep/1)

    {app_name, app_entry} = get_app_entry(deps)

    Map.put(deps, app_name, app_entry)
  end

  @spec get_application_config() :: Keyword.t()
  defp get_application_config do
    Mix.Project.get!().application()
  rescue
    UndefinedFunctionError -> []
  end

  @spec get_app_entry(dependencies :: %{Fetcher.app_name() => Fetcher.dependency()}) ::
          {Fetcher.app_name(), Fetcher.dependency()}
  defp get_app_entry(dependencies) do
    config = Mix.Project.config()

    links = config[:links] || config[:package][:links] || %{}
    source_url = config[:source_url] || Links.source_url(links)

    {config[:app],
     %{
       version: config[:version],
       optional: false,
       runtime: true,
       targets: :*,
       only: :*,
       licenses: config[:licenses] || config[:package][:licenses],
       dependencies: Map.keys(dependencies),
       root: true,
       source_url: source_url,
       links: links
     }}
  end

  @spec normalize_dep(
          dep ::
            {Fetcher.app_name(), String.t()}
            | {Fetcher.app_name(), Keyword.t()}
            | {Fetcher.app_name(), String.t() | nil, Keyword.t()}
        ) :: {Fetcher.app_name(), Fetcher.dependency()}
  defp normalize_dep(dep)

  defp normalize_dep({app, requirement}) when is_atom(app) and is_binary(requirement),
    do: normalize_dep({app, requirement, []})

  defp normalize_dep({app, opts}) when is_atom(app) and is_list(opts), do: normalize_dep({app, nil, opts})

  defp normalize_dep({app, requirement, opts})
       when is_atom(app) and (is_binary(requirement) or is_nil(requirement)) and is_list(opts) do
    bin_app = Atom.to_string(app)

    dest = Path.join(Mix.Project.deps_path(), bin_app)
    build = Path.join([Mix.Project.build_path(), "lib", bin_app])

    opts =
      opts
      |> Keyword.put(:dest, dest)
      |> Keyword.put(:build, build)

    {scm, opts} =
      Enum.find_value(Mix.SCM.available(), {nil, opts}, fn scm ->
        case scm.accepts_options(app, opts) do
          nil -> false
          opts -> {scm, opts}
        end
      end)

    app? =
      case Keyword.get(opts, :app, true) do
        false -> false
        _app_name -> true
      end

    {app,
     %{
       scm: scm,
       mix_dep: {app, requirement, opts},
       optional: Keyword.get(opts, :optional, false),
       runtime: Keyword.get(opts, :runtime, app?),
       targets: Keyword.get(opts, :targets, :*),
       only: Keyword.get(opts, :only, :*)
     }}
  end
end
