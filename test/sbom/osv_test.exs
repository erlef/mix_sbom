# SPDX-License-Identifier: BSD-3-Clause
# SPDX-FileCopyrightText: 2026 Erlang Ecosystem Foundation

defmodule SBoM.OSVTest do
  use ExUnit.Case, async: true

  import ExUnit.CaptureLog

  alias SBoM.OSV

  doctest OSV

  @components %{
    "kernel" => %{scm: SBoM.SCM.System, version: "10.0"},
    "stdlib" => %{scm: SBoM.SCM.System, version: "7.0"},
    "elixir" => %{scm: SBoM.SCM.System, version: "1.20.0"},
    "jason" => %{
      scm: Hex.SCM,
      mix_lock: [:hex, :jason, "1.4.0", "checksum", [:mix], [], "hexpm", "checksum"]
    },
    "purl" => %{scm: Mix.SCM.Git, mix_lock: [:git, "https://github.com/example/my_app.git", "abc123"]},
    # Without version (e.g. inside Burrito) the system app is not queried
    "logger" => %{scm: SBoM.SCM.System},
    # Path dependencies have no OSV query
    "optimus" => %{scm: Mix.SCM.Path}
  }

  describe "queries/1" do
    test "returns one query per SCM entry and groups identical queries" do
      queries = OSV.queries(@components)

      assert queries[%{"commit" => "abc123"}] == ["purl"]

      assert queries[%{"package" => %{"name" => "jason", "ecosystem" => "Hex"}, "version" => "1.4.0"}] ==
               ["jason"]

      assert queries[
               %{
                 "package" => %{"name" => "https://github.com/elixir-lang/elixir.git", "ecosystem" => "GIT"},
                 "version" => "1.20.0"
               }
             ] == ["elixir"]

      assert [otp_query] =
               queries
               |> Map.keys()
               |> Enum.filter(&match?(%{"package" => %{"name" => "https://github.com/erlang/otp.git"}}, &1))

      assert Enum.sort(queries[otp_query]) == ["kernel", "stdlib"]
      assert map_size(queries) == 4
    end
  end

  describe "vulnerabilities/2" do
    test "fetches every vulnerability once and maps it to all affected components" do
      {:ok, fetched} = Agent.start_link(fn -> [] end)

      vulnerabilities =
        OSV.vulnerabilities(@components,
          query_batch: &query_batch/1,
          get_vulnerability: fn id ->
            Agent.update(fetched, &[id | &1])
            {:ok, %{"id" => id, "summary" => "Summary of #{id}"}}
          end
        )

      assert fetched |> Agent.get(& &1) |> Enum.sort() == ["CVE-1", "CVE-2"]

      assert %{"CVE-1" => {cve_1, cve_1_affected}, "CVE-2" => {cve_2, ["purl"]}} =
               Map.new(vulnerabilities, fn {%{"id" => id} = vulnerability, names} -> {id, {vulnerability, names}} end)

      assert cve_1 == %{"id" => "CVE-1", "summary" => "Summary of CVE-1"}
      assert cve_2 == %{"id" => "CVE-2", "summary" => "Summary of CVE-2"}
      assert Enum.sort(cve_1_affected) == ["kernel", "purl", "stdlib"]
    end

    test "keeps the id and logs a warning when the details can not be fetched" do
      log =
        capture_log(fn ->
          vulnerabilities =
            OSV.vulnerabilities(@components,
              query_batch: &query_batch/1,
              get_vulnerability: fn _id -> {:error, :timeout} end
            )

          assert vulnerabilities |> Enum.map(&elem(&1, 0)) |> Enum.sort() == [%{"id" => "CVE-1"}, %{"id" => "CVE-2"}]
        end)

      assert log =~ "Failed to fetch vulnerability CVE-1 from OSV.dev"
    end

    test "logs a warning and returns no vulnerabilities when OSV.dev is unreachable" do
      log =
        capture_log(fn ->
          assert OSV.vulnerabilities(@components, query_batch: fn _queries -> {:error, :nxdomain} end) == []
        end)

      assert log =~ "Failed to fetch vulnerabilities from OSV.dev"
    end
  end

  @spec query_batch([OSV.query()]) :: {:ok, [map()]}
  def query_batch(queries) do
    {:ok,
     Enum.map(queries, fn
       %{"package" => %{"name" => "https://github.com/erlang/otp.git"}} -> %{"vulns" => [%{"id" => "CVE-1"}]}
       %{"commit" => _commit} -> %{"vulns" => [%{"id" => "CVE-1"}, %{"id" => "CVE-2"}]}
       _query -> %{}
     end)}
  end
end
