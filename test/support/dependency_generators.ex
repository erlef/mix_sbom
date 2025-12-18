# SPDX-License-Identifier: BSD-3-Clause
# SPDX-FileCopyrightText: 2025 Erlang Ecosystem Foundation
# SPDX-FileCopyrightText: 2025 Stritzinger GmbH

# credo:disable-for-this-file Credo.Check.Refactor.ABCSize
defmodule SBoM.DependencyGenerators do
  @moduledoc """
  StreamData generators for creating valid SBoM.Fetcher.dependency() types.

  These generators ensure that SCM, mix_dep, and mix_lock fields are coordinated
  and generate realistic dependency data for property-based testing.
  """

  use ExUnitProperties

  import StreamData

  # System app constraints from SBoM.SCM.System
  @elixir_applications ~w[eex elixir ex_unit iex logger mix]a
  @hex_app [:hex]

  {:ok, dirs} = :file.list_dir_all(:code.lib_dir())

  @erlang_applications Enum.map(dirs, fn dir ->
                         [name, _version] = dir |> List.to_string() |> String.split("-", parts: 2)
                         String.to_atom(name)
                       end)

  @system_applications @elixir_applications ++ @erlang_applications ++ @hex_app

  @doc """
  Generates a valid app name for system dependencies.
  """
  @spec system_app_name() :: StreamData.t(Application.app())
  def system_app_name do
    member_of(@system_applications)
  end

  @doc """
  Generates an arbitrary app name for non-system dependencies.
  """
  @spec app_name() :: StreamData.t(Application.app())
  def app_name do
    :alphanumeric
    |> string(min_length: 2, max_length: 20)
    |> map(&String.to_atom/1)
  end

  @doc """
  Generates a semantic version string.
  """
  @spec version_string() :: StreamData.t(String.t() | nil)
  def version_string do
    frequency([
      {8, semantic_version()},
      {1, constant(nil)},
      {1, git_ref()}
    ])
  end

  @spec semantic_version() :: StreamData.t(String.t())
  defp semantic_version do
    {integer(0..10), integer(0..20), integer(0..100)}
    |> tuple()
    |> map(fn {major, minor, patch} -> "#{major}.#{minor}.#{patch}" end)
  end

  @spec git_ref() :: StreamData.t(String.t())
  defp git_ref do
    one_of([
      # Git commit hash
      :alphanumeric |> string(length: 40) |> map(&String.downcase/1),
      # Git tag
      map(semantic_version(), &("v" <> &1)),
      # Branch name
      one_of([constant("main"), constant("master"), constant("develop")])
    ])
  end

  @doc """
  Generates a version requirement string.
  """
  @spec requirement_string() :: StreamData.t(String.t() | nil)
  def requirement_string do
    frequency([
      {5, map(semantic_version(), &("~> " <> &1))},
      {2, map(semantic_version(), &(">= " <> &1))},
      {2, semantic_version()},
      {1, constant(nil)}
    ])
  end

  @doc """
  Generates a realistic Git repository URL.
  """
  @spec git_url() :: StreamData.t(String.t())
  def git_url do
    frequency([
      {6, github_url()},
      {2, gitlab_url()},
      {1, generic_git_url()},
      {1, ssh_git_url()}
    ])
  end

  @spec github_url() :: StreamData.t(String.t())
  defp github_url do
    {app_name(), app_name()}
    |> tuple()
    |> map(fn {user, repo} -> "https://github.com/#{user}/#{repo}.git" end)
  end

  @spec gitlab_url() :: StreamData.t(String.t())
  defp gitlab_url do
    {app_name(), app_name()}
    |> tuple()
    |> map(fn {user, repo} -> "https://gitlab.com/#{user}/#{repo}.git" end)
  end

  @spec generic_git_url() :: StreamData.t(String.t())
  defp generic_git_url do
    {app_name(), app_name(), app_name()}
    |> tuple()
    |> map(fn {host, user, repo} -> "https://git.#{host}.com/#{user}/#{repo}.git" end)
  end

  @spec ssh_git_url() :: StreamData.t(String.t())
  defp ssh_git_url do
    {app_name(), app_name()}
    |> tuple()
    |> map(fn {user, repo} -> "git@github.com:#{user}/#{repo}.git" end)
  end

  @doc """
  Generates a file path for path dependencies.
  """
  @spec file_path() :: StreamData.t(String.t())
  def file_path do
    frequency([
      {5,
       gen all(name <- app_name()) do
         "../deps/#{name}"
       end},
      {3,
       gen all(name <- app_name()) do
         "./#{name}"
       end},
      {2,
       gen all(name <- app_name()) do
         "deps/#{name}"
       end}
    ])
  end

  @doc """
  Generates target specifications.
  """
  @spec targets() :: StreamData.t(:* | [atom()])
  def targets do
    frequency([
      {4, constant(:*)},
      {3, list_of(member_of([:host]), min_length: 1, max_length: 3)},
      {2, member_of([[:host]])},
      {1, list_of(atom(:alphanumeric), min_length: 1, max_length: 2)}
    ])
  end

  @doc """
  Generates environment specifications.
  """
  @spec environments() :: StreamData.t(:* | [atom()])
  def environments do
    frequency([
      {4, constant(:*)},
      {3, list_of(member_of([:dev, :test, :prod]), min_length: 1, max_length: 3)},
      {2, member_of([[:dev], [:test], [:prod], [:dev, :test]])},
      {1, list_of(atom(:alphanumeric), min_length: 1, max_length: 2)}
    ])
  end

  @doc """
  Generates license strings.
  """
  @spec licenses() :: StreamData.t([String.t()] | nil)
  def licenses do
    frequency([
      {1, constant(nil)},
      {4,
       list_of(member_of(["MIT", "Apache-2.0", "BSD-3-Clause", "GPL-3.0", "ISC"]),
         min_length: 1,
         max_length: 2
       )}
    ])
  end

  @doc """
  Generates description strings.
  """
  @spec description() :: StreamData.t(String.t() | nil)
  def description do
    frequency([
      {3, constant(nil)},
      {7, string(:printable, min_length: 10, max_length: 100)}
    ])
  end

  @doc """
  Generates links map for SBoM.Fetcher.Links.t().
  """
  @spec links() :: StreamData.t(%{String.t() => String.t()})
  def links do
    frequency([
      {2, constant(%{})},
      {3,
       map_of(
         one_of([
           member_of(["github", "gitlab", "homepage", "documentation", "repository"]),
           string(:alphanumeric, min_length: 3, max_length: 15)
         ]),
         git_url(),
         max_length: 3
       )}
    ])
  end

  @doc """
  Generates a hex checksum.
  """
  @spec hex_checksum() :: StreamData.t(String.t())
  def hex_checksum do
    :alphanumeric |> string(length: 64) |> map(&String.downcase/1)
  end

  @doc """
  Generates a dependency list for mix_lock deps field.
  """
  @spec dependency_list() :: StreamData.t([{Application.app(), String.t() | nil, []}])
  def dependency_list do
    list_of(
      tuple({app_name(), requirement_string(), constant([])}),
      max_length: 5
    )
  end

  @doc """
  Generates a Hex dependency with coordinated SCM, mix_dep, and mix_lock fields.
  """
  @spec hex_dependency() :: StreamData.t(SBoM.Fetcher.dependency())
  def hex_dependency do
    gen all(
          app <- app_name(),
          description <- description(),
          version <- version_string(),
          req <- requirement_string(),
          repo <- member_of(["hexpm", "hexpm:myorg", "private"]),
          inner_checksum <- hex_checksum(),
          outer_checksum <- hex_checksum(),
          deps <- dependency_list(),
          optional <- boolean(),
          runtime <- boolean(),
          targets <- targets(),
          only <- environments(),
          dependencies <- list_of(app_name(), max_length: 3),
          mix_config <- constant([]),
          licenses <- licenses(),
          root <- boolean(),
          source_url <- frequency([{3, constant(nil)}, {1, git_url()}]),
          links <- links()
        ) do
      mix_dep = {app, req, [hex: app, repo: repo]}

      mix_lock =
        version &&
          [
            :hex,
            app,
            version,
            inner_checksum,
            [:mix],
            deps,
            repo,
            outer_checksum
          ]

      base_fields = %{
        scm: Mix.SCM.Hex,
        mix_dep: mix_dep
      }

      base_fields
      |> maybe_put(:version, version)
      |> maybe_put(:version_requirement, req)
      |> maybe_put(:mix_lock, mix_lock)
      |> maybe_put(:runtime, runtime)
      |> maybe_put(:optional, optional)
      |> maybe_put(:targets, targets)
      |> maybe_put(:only, only)
      |> maybe_put(:dependencies, dependencies)
      |> maybe_put(:mix_config, mix_config)
      |> maybe_put(:licenses, licenses)
      |> maybe_put(:root, root)
      |> maybe_put(:source_url, source_url)
      |> maybe_put(:links, links)
      |> maybe_put(:description, description)
    end
  end

  @doc """
  Generates a Git dependency with coordinated SCM, mix_dep, and mix_lock fields.
  """
  @spec git_dependency() :: StreamData.t(SBoM.Fetcher.dependency())
  def git_dependency do
    gen all(
          app <- app_name(),
          description <- description(),
          git_url <- git_url(),
          version <- version_string(),
          req <- requirement_string(),
          ref_type <- member_of([:tag, :ref, :branch]),
          ref_value <- git_ref(),
          commit_hash <- :alphanumeric |> string(length: 40) |> map(&String.downcase/1),
          optional <- boolean(),
          runtime <- boolean(),
          targets <- targets(),
          only <- environments(),
          dependencies <- list_of(app_name(), max_length: 3),
          mix_config <- constant([]),
          licenses <- licenses(),
          root <- boolean(),
          links <- links()
        ) do
      git_opts = [{:git, git_url}, {ref_type, ref_value}]
      mix_dep = {app, req, git_opts}
      mix_lock = [:git, git_url, commit_hash]

      base_fields = %{
        scm: Mix.SCM.Git,
        mix_dep: mix_dep,
        mix_lock: mix_lock,
        source_url: git_url
      }

      base_fields
      |> maybe_put(:version, version || ref_value)
      |> maybe_put(:version_requirement, req)
      |> maybe_put(:runtime, runtime)
      |> maybe_put(:optional, optional)
      |> maybe_put(:targets, targets)
      |> maybe_put(:only, only)
      |> maybe_put(:dependencies, dependencies)
      |> maybe_put(:mix_config, mix_config)
      |> maybe_put(:licenses, licenses)
      |> maybe_put(:root, root)
      |> maybe_put(:links, links)
      |> maybe_put(:description, description)
    end
  end

  @doc """
  Generates a Path dependency with coordinated SCM and mix_dep fields.
  Path dependencies don't have mix_lock entries.
  """
  @spec path_dependency() :: StreamData.t(SBoM.Fetcher.dependency())
  def path_dependency do
    gen all(
          app <- app_name(),
          description <- description(),
          path <- file_path(),
          version <- version_string(),
          req <- requirement_string(),
          optional <- boolean(),
          runtime <- boolean(),
          targets <- targets(),
          only <- environments(),
          dependencies <- list_of(app_name(), max_length: 3),
          mix_config <- constant([]),
          licenses <- licenses(),
          root <- boolean(),
          source_url <- frequency([{5, constant(nil)}, {1, git_url()}]),
          links <- links()
        ) do
      mix_dep = {app, req, [path: path]}

      base_fields = %{
        scm: Mix.SCM.Path,
        mix_dep: mix_dep
      }

      base_fields
      |> maybe_put(:version, version)
      |> maybe_put(:version_requirement, req)
      |> maybe_put(:runtime, runtime)
      |> maybe_put(:optional, optional)
      |> maybe_put(:targets, targets)
      |> maybe_put(:only, only)
      |> maybe_put(:dependencies, dependencies)
      |> maybe_put(:mix_config, mix_config)
      |> maybe_put(:licenses, licenses)
      |> maybe_put(:root, root)
      |> maybe_put(:source_url, source_url)
      |> maybe_put(:links, links)
      |> maybe_put(:description, description)
    end
  end

  @doc """
  Generates a System dependency with coordinated SCM and mix_dep fields.
  System dependencies don't have mix_lock entries and use constrained app names.
  """
  @spec system_dependency() :: StreamData.t(SBoM.Fetcher.dependency())
  def system_dependency do
    gen all(
          app <- system_app_name(),
          description <- description(),
          version <- frequency([{7, constant(nil)}, {3, version_string()}]),
          # System deps are never optional
          optional <- constant(false),
          # System deps are always runtime
          runtime <- constant(true),
          # System deps target everything
          targets <- constant(:*),
          # System deps in all environments
          only <- constant(:*),
          dependencies <- list_of(system_app_name(), max_length: 2),
          mix_config <- constant([]),
          licenses <- licenses(),
          root <- boolean(),
          links <- links()
        ) do
      mix_dep = {app, nil, []}

      base_fields = %{
        scm: SBoM.SCM.System,
        mix_dep: mix_dep,
        optional: optional,
        runtime: runtime,
        targets: targets,
        only: only
      }

      base_fields
      |> maybe_put(:version, version)
      |> maybe_put(:dependencies, dependencies)
      |> maybe_put(:mix_config, mix_config)
      |> maybe_put(:licenses, licenses)
      |> maybe_put(:root, root)
      |> maybe_put(:links, links)
      |> maybe_put(:description, description)
    end
  end

  @doc """
  Generates a valid SBoM.Fetcher.dependency() with proper SCM coordination.

  This is the main generator that combines all SCM types with appropriate
  frequency distribution to create realistic dependency data.
  """
  @spec dependency() :: StreamData.t(SBoM.Fetcher.dependency())
  def dependency do
    frequency([
      # Hex dependencies are most common
      {6, hex_dependency()},
      # Git dependencies are fairly common
      {2, git_dependency()},
      # Path dependencies are less common
      {1, path_dependency()},
      # System dependencies are built-in
      {1, system_dependency()}
    ])
  end

  @doc """
  Generates a map of app names to dependencies, similar to what SBoM.Fetcher.fetch/0 returns.
  """
  @spec dependency_map() :: StreamData.t(%{String.t() => SBoM.Fetcher.dependency()})
  def dependency_map do
    gen all(
          deps <-
            list_of(
              tuple({app_name(), dependency()}),
              min_length: 1,
              max_length: 10
            )
        ) do
      # Convert to map, handling duplicate keys by taking the last value
      deps
      |> Map.new()
      |> Map.new(fn {app, dep} -> {Atom.to_string(app), dep} end)
    end
  end

  # Helper function to conditionally add fields to a map
  @spec maybe_put(map(), any(), any()) :: map()
  defp maybe_put(map, _key, nil), do: map
  defp maybe_put(map, _key, []), do: map
  defp maybe_put(map, _key, %{} = value) when map_size(value) == 0, do: map
  defp maybe_put(map, key, value), do: Map.put(map, key, value)
end
