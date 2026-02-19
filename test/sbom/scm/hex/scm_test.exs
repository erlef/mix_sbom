# SPDX-License-Identifier: BSD-3-Clause
# SPDX-FileCopyrightText: 2025 Erlang Ecosystem Foundation
# SPDX-FileCopyrightText: 2025 Stritzinger GmbH

defmodule SBoM.SCM.Hex.SCMTest do
  use SBoM.FixtureCase, async: false

  alias SBoM.SCM.Hex.SCM

  doctest SCM

  setup do
    Mix.Shell.Process.flush()

    shell = Mix.shell(Mix.Shell.Process)

    on_exit(fn ->
      Mix.shell(shell)
    end)

    :ok
  end

  describe "enhance_metadata/2" do
    test "returns empty map when all metadata keys are present" do
      dependency = %{
        licenses: ["MIT"],
        source_url: "https://example.com",
        links: %{"homepage" => "https://example.com"},
        description: "An example package."
      }

      assert SCM.enhance_metadata(:jason, dependency) == %{}
    end

    test "attempts to fetch when metadata keys have empty list or empty map values" do
      dependency = %{
        licenses: [],
        source_url: nil,
        links: %{}
      }

      assert_response(fn -> SCM.enhance_metadata(:jason, dependency) end, fn response ->
        assert %{
                 description: "A blazing fast JSON parser and generator in pure Elixir.",
                 licenses: ["Apache-2.0"],
                 links: %{
                   "docs" => "https://hexdocs.pm/jason/",
                   "github" => "https://github.com/michalmuskala/jason",
                   "homepage" => "https://hex.pm/packages/jason"
                 },
                 source_url: "https://github.com/michalmuskala/jason"
               } = response
      end)
    end

    test "attempts to fetch when metadata keys are missing" do
      dependency = %{version: "1.4.4"}

      assert_response(fn -> SCM.enhance_metadata(:jason, dependency) end, fn response ->
        assert %{
                 description: "A blazing fast JSON parser and generator in pure Elixir.",
                 licenses: ["Apache-2.0"],
                 links: %{
                   "docs" => "https://hexdocs.pm/jason/1.4.4/",
                   "github" => "https://github.com/michalmuskala/jason",
                   "homepage" => "https://hex.pm/packages/jason/1.4.4"
                 },
                 source_url: "https://github.com/michalmuskala/jason"
               } = response
      end)
    end

    test "attempts to fetch when some metadata keys are missing" do
      dependency = %{
        licenses: ["MIT"],
        version: "1.4.4"
      }

      assert_response(fn -> SCM.enhance_metadata(:jason, dependency) end, fn response ->
        assert %{
                 description: "A blazing fast JSON parser and generator in pure Elixir.",
                 licenses: ["Apache-2.0"],
                 links: %{
                   "docs" => "https://hexdocs.pm/jason/1.4.4/",
                   "github" => "https://github.com/michalmuskala/jason",
                   "homepage" => "https://hex.pm/packages/jason/1.4.4"
                 },
                 source_url: "https://github.com/michalmuskala/jason"
               } = response
      end)
    end
  end

  @spec assert_response(load :: (-> response), assert :: (response -> any() | no_return())) :: :ok when response: any()
  defp assert_response(load, assert) do
    response = load.()

    receive do
      {:mix_shell, :error, ["Hex API rate limit exceeded"]} ->
        :ok
    after
      0 ->
        assert.(response)
    end
  end

  describe "group/2" do
    test "returns repo from mix_lock" do
      dependency = %{
        mix_lock: [:hex, :jason, "1.4.0", "checksum", [:mix], [], "hexpm", "checksum"]
      }

      assert SCM.group(:jason, dependency) == "hexpm"
    end

    test "returns repo with org from mix_lock" do
      dependency = %{
        mix_lock: [:hex, :private_pkg, "1.0.0", "checksum", [:mix], [], "hexpm:myorg", "checksum"]
      }

      assert SCM.group(:private_pkg, dependency) == "hexpm:myorg"
    end

    test "returns repo from mix_dep when no mix_lock" do
      dependency = %{
        mix_dep: {:jason, "~> 1.0", [hex: :jason, repo: "hexpm"]}
      }

      assert SCM.group(:jason, dependency) == "hexpm"
    end

    test "returns repo with org from mix_dep" do
      dependency = %{
        mix_dep: {:private_pkg, "~> 1.0", [hex: :private_pkg, repo: "hexpm:myorg"]}
      }

      assert SCM.group(:private_pkg, dependency) == "hexpm:myorg"
    end

    test "returns nil when no hex info available" do
      assert SCM.group(:app, %{}) == nil
    end
  end
end
