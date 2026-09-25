# SPDX-License-Identifier: BSD-3-Clause
# SPDX-FileCopyrightText: 2026 Erlang Ecosystem Foundation

defmodule SBoM.OSV do
  @moduledoc false

  # Looks up known vulnerabilities of components on OSV.dev.
  #
  # Every SCM implementation returns the OSV.dev query for its dependencies
  # (see `c:SBoM.SCM.osv_query/2`). Identical queries (for example all Erlang/OTP
  # applications) are sent only once, using the `querybatch` API.

  alias SBoM.CycloneDX.JSON
  alias SBoM.Fetcher
  alias SBoM.SCM

  require Logger

  @url ~c"https://api.osv.dev/v1/querybatch"

  # OSV.dev accepts at most 1000 queries per request.
  @batch_size 1000

  @type query() :: map()
  @type response() :: {:ok, [map()]} | {:error, term()}

  @doc """
  Returns the ids of the vulnerabilities found for the given components,
  mapped to the names of the affected components.

  Unreachable OSV.dev only logs a warning and returns no vulnerabilities.

  ## Examples

      iex> components = %{
      ...>   "jason" => %{
      ...>     scm: Hex.SCM,
      ...>     mix_lock: [:hex, :jason, "1.4.0", "checksum", [:mix], [], "hexpm", "checksum"]
      ...>   }
      ...> }
      ...>
      ...> SBoM.OSV.vulnerabilities(components, fn [_query] ->
      ...>   {:ok, [%{"vulns" => [%{"id" => "GHSA-xxxx", "modified" => "2026-01-01T00:00:00Z"}]}]}
      ...> end)
      %{"GHSA-xxxx" => ["jason"]}

  """
  @spec vulnerabilities(
          %{String.t() => Fetcher.dependency()},
          request :: ([query()] -> response())
        ) :: %{String.t() => [String.t()]}
  def vulnerabilities(components, request \\ &request/1) do
    queries = queries(components)

    queries
    |> Map.keys()
    |> Enum.chunk_every(@batch_size)
    |> Enum.flat_map(fn batch ->
      case request.(batch) do
        {:ok, results} ->
          Enum.zip(batch, results)

        {:error, reason} ->
          Logger.warning("Failed to fetch vulnerabilities from OSV.dev, reason: #{inspect(reason)}")

          []
      end
    end)
    |> Enum.reduce(%{}, fn {query, result}, acc ->
      names = Map.fetch!(queries, query)

      # ponytail: a query with more than 1000 vulns is paginated by OSV.dev
      # (`next_page_token`); only the first page is used.
      for %{"id" => id} <- Map.get(result, "vulns", []), reduce: acc do
        acc -> Map.update(acc, id, names, &Enum.uniq(&1 ++ names))
      end
    end)
  end

  @doc false
  @spec queries(%{String.t() => Fetcher.dependency()}) :: %{query() => [String.t()]}
  def queries(components) do
    # Filters that evaluate to `nil` skip the component.
    for {name, %{scm: scm} = dependency} <- components,
        impl = SCM.implementation(scm),
        function_exported?(impl, :osv_query, 2),
        query = name |> String.to_existing_atom() |> impl.osv_query(dependency),
        reduce: %{} do
      acc -> Map.update(acc, query, [name], &[name | &1])
    end
  end

  @spec request([query()]) :: response()
  defp request(queries) do
    {:ok, _apps} = Application.ensure_all_started([:inets, :ssl])

    body = JSON.encode_json(%{"queries" => queries}, false)

    http_options = [
      timeout: 60_000,
      ssl: [
        verify: :verify_peer,
        cacerts: :public_key.cacerts_get(),
        customize_hostname_check: [match_fun: :public_key.pkix_verify_hostname_match_fun(:https)]
      ]
    ]

    case :httpc.request(:post, {@url, [], ~c"application/json", body}, http_options, body_format: :binary) do
      {:ok, {{_http_version, 200, _reason}, _headers, response}} ->
        case JSON.decode_json(response) do
          %{"results" => results} when is_list(results) -> {:ok, results}
          other -> {:error, {:unexpected_response, other}}
        end

      {:ok, {{_http_version, status, _reason}, _headers, _response}} ->
        {:error, {:http_status, status}}

      {:error, reason} ->
        {:error, reason}
    end
  end
end
