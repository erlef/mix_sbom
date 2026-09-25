# SPDX-License-Identifier: BSD-3-Clause
# SPDX-FileCopyrightText: 2026 Erlang Ecosystem Foundation

defmodule SBoM.OSV do
  @moduledoc false

  # Looks up known vulnerabilities of components on OSV.dev.
  #
  # Every SCM implementation returns the OSV.dev query for its dependencies
  # (see `c:SBoM.SCM.osv_query/2`). Identical queries (for example all Erlang/OTP
  # applications) are sent only once, using the `querybatch` API. It only
  # returns the ids of the vulnerabilities, so the details of every found
  # vulnerability are fetched afterwards, once per id and in parallel.

  alias SBoM.CycloneDX.JSON
  alias SBoM.Fetcher
  alias SBoM.SCM

  require Logger

  @base_url "https://api.osv.dev/v1"

  # OSV.dev accepts at most 1000 queries per request.
  @batch_size 1000

  @timeout 60_000

  @type query() :: map()
  @type vulnerability() :: %{required(String.t()) => term()}
  @type response(result) :: {:ok, result} | {:error, term()}

  @type option() ::
          {:query_batch, ([query()] -> response([map()]))}
          | {:get_vulnerability, (String.t() -> response(vulnerability()))}

  @doc """
  Returns the vulnerabilities (OSV.dev records) found for the given components,
  each with the names of the affected components.

  Unreachable OSV.dev only logs a warning. A vulnerability whose details can
  not be fetched is still returned with its id.

  The HTTP requests can be replaced with the `:query_batch` and
  `:get_vulnerability` options.

  ## Examples

      iex> components = %{
      ...>   "jason" => %{
      ...>     scm: Hex.SCM,
      ...>     mix_lock: [:hex, :jason, "1.4.0", "checksum", [:mix], [], "hexpm", "checksum"]
      ...>   }
      ...> }
      ...>
      ...> SBoM.OSV.vulnerabilities(components,
      ...>   query_batch: fn [_query] -> {:ok, [%{"vulns" => [%{"id" => "GHSA-xxxx"}]}]} end,
      ...>   get_vulnerability: fn id -> {:ok, %{"id" => id, "summary" => "Example"}} end
      ...> )
      [{%{"id" => "GHSA-xxxx", "summary" => "Example"}, ["jason"]}]

  """
  @spec vulnerabilities(%{String.t() => Fetcher.dependency()}, [option()]) ::
          [{vulnerability(), affected :: [String.t()]}]
  def vulnerabilities(components, opts \\ []) do
    query_batch = Keyword.get(opts, :query_batch, &query_batch/1)
    get_vulnerability = Keyword.get(opts, :get_vulnerability, &get_vulnerability/1)

    components
    |> affected_components(query_batch)
    |> Task.async_stream(fn {id, names} -> {details(id, get_vulnerability), names} end,
      timeout: @timeout * 2
    )
    |> Enum.map(fn {:ok, result} -> result end)
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

  @spec affected_components(%{String.t() => Fetcher.dependency()}, ([query()] ->
                                                                      response([map()]))) ::
          %{String.t() => [String.t()]}
  defp affected_components(components, query_batch) do
    queries = queries(components)

    queries
    |> Map.keys()
    |> Enum.chunk_every(@batch_size)
    |> Enum.flat_map(fn batch ->
      case query_batch.(batch) do
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

  @spec details(String.t(), (String.t() -> response(vulnerability()))) :: vulnerability()
  defp details(id, get_vulnerability) do
    case get_vulnerability.(id) do
      {:ok, vulnerability} ->
        vulnerability

      {:error, reason} ->
        Logger.warning("Failed to fetch vulnerability #{id} from OSV.dev, reason: #{inspect(reason)}")

        %{"id" => id}
    end
  end

  @spec query_batch([query()]) :: response([map()])
  defp query_batch(queries) do
    case request(:post, "/querybatch", %{"queries" => queries}) do
      {:ok, %{"results" => results}} when is_list(results) -> {:ok, results}
      {:ok, other} -> {:error, {:unexpected_response, other}}
      {:error, reason} -> {:error, reason}
    end
  end

  @spec get_vulnerability(String.t()) :: response(vulnerability())
  defp get_vulnerability(id), do: request(:get, "/vulns/" <> URI.encode(id))

  @spec request(:get | :post, path :: String.t(), body :: map() | nil) :: response(term())
  defp request(method, path, body \\ nil) do
    {:ok, _apps} = Application.ensure_all_started([:inets, :ssl])

    url = String.to_charlist(@base_url <> path)

    request =
      case body do
        nil -> {url, []}
        body -> {url, [], ~c"application/json", JSON.encode_json(body, false)}
      end

    http_options = [
      timeout: @timeout,
      ssl: [
        verify: :verify_peer,
        cacerts: :public_key.cacerts_get(),
        customize_hostname_check: [match_fun: :public_key.pkix_verify_hostname_match_fun(:https)]
      ]
    ]

    case :httpc.request(method, request, http_options, body_format: :binary) do
      {:ok, {{_http_version, 200, _reason}, _headers, response}} ->
        {:ok, JSON.decode_json(response)}

      {:ok, {{_http_version, status, _reason}, _headers, _response}} ->
        {:error, {:http_status, status}}

      {:error, reason} ->
        {:error, reason}
    end
  end
end
