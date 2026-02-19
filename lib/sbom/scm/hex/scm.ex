# SPDX-License-Identifier: BSD-3-Clause
# SPDX-FileCopyrightText: 2025 Erlang Ecosystem Foundation
# SPDX-FileCopyrightText: 2025 Stritzinger GmbH

defmodule SBoM.SCM.Hex.SCM do
  @moduledoc false

  # SCM implementation for Hex packages.
  #
  # Handles the conversion of Hex dependencies into `purl` format and extraction
  # of dependency information from `mix.exs` and `mix.lock`.

  @behaviour SBoM.SCM

  alias SBoM.Metadata
  alias SBoM.SCM

  @doc """
  Creates a package URL (`purl`) from a declared Mix dependency (`mix.exs`).

  Attempts to resolve the repository URL and include it as a `qualifier`.

  ## Examples

      iex> SBoM.SCM.Hex.SCM.mix_dep_to_purl(
      ...>   {:jason, "~> 1.0", [hex: :jason, repo: "hexpm"]},
      ...>   "1.4.0"
      ...> )
      %Purl{
        type: "hex",
        namespace: [],
        name: "jason",
        version: "1.4.0",
        qualifiers: %{}
      }
  """
  @impl SCM
  def mix_dep_to_purl({_app, requirement, opts}, version) do
    repository_url =
      case repository_url(opts[:repo]) do
        {:ok, url} -> url
        :error -> nil
      end

    qualifiers =
      case repository_url do
        "https://repo.hex.pm" -> %{}
        # Unknown repository URL, do not include it in the qualifiers
        # to avoid exposing it in the PURL.
        nil -> %{}
        ^repository_url -> %{"repository_url" => repository_url}
      end

    Purl.new!(%Purl{
      type: "hex",
      namespace: hex_namespace(opts[:repo]),
      name: opts |> Keyword.fetch!(:hex) |> to_string(),
      version: version || requirement,
      qualifiers: qualifiers
    })
  end

  @doc """
  Creates a package URL (`purl`) from a locked dependency (`mix.lock` entry).

  Attempts to include the repository URL as a `qualifier`, if resolvable.

  ## Examples

      iex> lock = [
      ...>   :hex,
      ...>   :jason,
      ...>   "1.4.0",
      ...>   "checksum",
      ...>   [:mix],
      ...>   [],
      ...>   "hexpm",
      ...>   "checksum"
      ...> ]
      ...>
      ...> SBoM.SCM.Hex.SCM.mix_lock_to_purl(:jason, lock)
      %Purl{
        type: "hex",
        namespace: [],
        name: "jason",
        version: "1.4.0",
        qualifiers: %{
          "checksum" => "sha256:checksum",
          "download_url" => "https://repo.hex.pm/tarballs/jason-1.4.0.tar"
        }
      }
  """
  @impl SCM
  def mix_lock_to_purl(_app, lock) do
    [
      :hex,
      package_name,
      version,
      _inner_checksum,
      _managers,
      _deps,
      repo,
      outer_checksum | _rest
    ] = lock

    repository_url =
      case repository_url(repo) do
        {:ok, url} -> url
        :error -> nil
      end

    qualifiers = %{
      "checksum" => "sha256:#{outer_checksum}"
    }

    qualifiers =
      case repository_url do
        "https://repo.hex.pm" -> qualifiers
        # Unknown repository URL, do not include it in the qualifiers
        # to avoid exposing it in the PURL.
        nil -> qualifiers
        ^repository_url -> Map.put(qualifiers, "repository_url", repository_url)
      end

    qualifiers =
      case repository_url do
        nil ->
          qualifiers

        ^repository_url ->
          Map.put(
            qualifiers,
            "download_url",
            "#{repository_url}/tarballs/#{package_name}-#{version}.tar"
          )
      end

    Purl.new!(%Purl{
      type: "hex",
      namespace: hex_namespace(repo),
      name: Atom.to_string(package_name),
      version: version,
      qualifiers: qualifiers
    })
  end

  @doc """
  Returns the list of app names that are dependencies of the given locked dependency.

  ## Examples

      iex> lock = [
      ...>   :hex,
      ...>   :my_app,
      ...>   "0.1.0",
      ...>   "checksum",
      ...>   [:mix],
      ...>   [
      ...>     {:dep_a, "~> 0.1.0", [hex: :dep_a]},
      ...>     {:dep_b, "~> 0.2.0", [hex: :dep_b]}
      ...>   ],
      ...>   "hexpm",
      ...>   "checksum"
      ...> ]
      ...>
      ...> SBoM.SCM.Hex.SCM.mix_lock_deps(lock)
      [:dep_a, :dep_b]
  """
  @impl SCM
  def mix_lock_deps(lock) do
    [
      :hex,
      _package_name,
      _version,
      _inner_checksum,
      _managers,
      deps,
      _repo,
      _outer_checksum | _rest
    ] = lock

    Enum.map(deps, fn {app, _requirement, _opts} -> app end)
  end

  @doc """
  Extracts the version string from a locked dependency.

  ## Examples

      iex> lock = [
      ...>   :hex,
      ...>   :jason,
      ...>   "1.4.0",
      ...>   "checksum",
      ...>   [:mix],
      ...>   [],
      ...>   "hexpm",
      ...>   "checksum"
      ...> ]
      ...>
      ...> SBoM.SCM.Hex.SCM.mix_lock_version(lock)
      "1.4.0"

  """
  @impl SCM
  def mix_lock_version(lock) do
    [
      :hex,
      _package_name,
      version,
      _inner_checksum,
      _managers,
      _deps,
      _repo,
      _outer_checksum | _rest
    ] = lock

    version
  end

  @doc """
  Enhances dependency metadata by fetching additional information from the Hex API.

  Returns a map with metadata fields (licenses, links, source_url) that can be
  merged with existing dependency information. Returns an empty map on error.
  """
  @impl SCM
  def enhance_metadata(app, dependency) do
    # Check if any metadata key is missing or has empty/nil values
    # Handle both atom and string keys in the dependency map
    needs_fetch =
      Enum.any?(Metadata.keys(), fn key ->
        value = get_metadata_value(dependency, key)
        value_empty?(value)
      end)

    if needs_fetch do
      fetch_hex_metadata(app, dependency[:version])
    else
      %{}
    end
  end

  @spec get_metadata_value(map(), atom()) :: term()
  defp get_metadata_value(dependency, key) when is_atom(key) do
    # Try atom key first, then string key
    Map.get(dependency, key) || Map.get(dependency, Atom.to_string(key))
  end

  @spec value_empty?(term()) :: boolean()
  defp value_empty?(value)
  defp value_empty?(nil), do: true
  defp value_empty?([]), do: true
  defp value_empty?(%{} = map) when map_size(map) == 0, do: true
  defp value_empty?(_value), do: false

  @spec fetch_hex_metadata(Application.app(), String.t() | nil) :: map()
  defp fetch_hex_metadata(app, version) do
    package_payload =
      :hex_core.default_config()
      |> :hex_api_package.get(Atom.to_string(app))
      |> hex_response()

    release_payload =
      if version do
        :hex_core.default_config()
        |> :hex_api_release.get(Atom.to_string(app), version)
        |> hex_response()
      else
        %{}
      end

    SBoM.Fetcher.merge(
      app,
      Metadata.from_hex_payload(package_payload),
      Metadata.from_hex_payload(release_payload)
    )
  end

  @impl SCM
  def group(_app, %{mix_lock: [:hex, _name, _version, _checksum, _managers, _deps, repo | _rest]}), do: repo

  def group(_app, %{mix_dep: {_name, _requirement, opts}}), do: opts[:repo]
  def group(_app, _dependency), do: nil

  @spec hex_namespace(repo :: String.t() | nil) :: Purl.namespace()
  defp hex_namespace(repo)
  defp hex_namespace(nil), do: []
  defp hex_namespace("hexpm"), do: []
  defp hex_namespace("hexpm:" <> organisation), do: [organisation]
  defp hex_namespace(repo), do: String.split(repo, ":")

  @spec repository_url(repo :: String.t() | nil) :: {:ok, Purl.qualifier_value()} | :error
  defp repository_url(repo)
  defp repository_url(nil), do: repository_url("hexpm")

  defp repository_url(repo) do
    with {:ok, %{url: url}} <- Hex.Repo.fetch_repo(repo) do
      {:ok, url}
    end
  end

  @spec hex_response({:ok, response} | {:error, term()}) :: payload | %{}
        when response: {200..599, map(), payload}, payload: map()
  defp hex_response(response)
  defp hex_response({:ok, {200, _headers, payload}}), do: payload

  defp hex_response({:ok, {429, _headers, _payload}}) do
    Mix.shell().error("Hex API rate limit exceeded")
    %{}
  end

  defp hex_response({:ok, {_status, _headers, _payload} = response}),
    do:
      raise("""
      Unexpected Hex API response: #{inspect(response)}
      """)

  defp hex_response({:error, reason}),
    do:
      raise("""
      Error fetching from Hex API: #{inspect(reason)}
      """)
end
