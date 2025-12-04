# SPDX-License-Identifier: BSD-3-Clause
# SPDX-FileCopyrightText: 2025 Erlang Ecosystem Foundation

defmodule SBoM.SCM.Hex.SCMTest do
  use SBoM.FixtureCase, async: false

  alias SBoM.SCM.Hex.SCM

  doctest SCM

  describe "enhance_metadata/2" do
    test "returns empty map when all metadata keys are present" do
      dependency = %{
        licenses: ["MIT"],
        source_url: "https://example.com",
        links: %{"homepage" => "https://example.com"},
        description: "An example package."
      }

      result = SCM.enhance_metadata(:test_app, dependency)
      assert result == %{}
    end

    test "attempts to fetch when metadata keys have empty list or empty map values" do
      dependency = %{
        licenses: [],
        source_url: nil,
        links: %{}
      }

      assert %{
               description: "A blazing fast JSON parser and generator in pure Elixir.",
               licenses: ["Apache-2.0"],
               links: %{
                 "docs" => "https://hexdocs.pm/jason/",
                 "github" => "https://github.com/michalmuskala/jason",
                 "homepage" => "https://hex.pm/packages/jason"
               },
               source_url: "https://github.com/michalmuskala/jason"
             } = SCM.enhance_metadata(:jason, dependency)
    end

    test "attempts to fetch when metadata keys are missing" do
      dependency = %{version: "1.4.4"}

      assert %{
               description: "A blazing fast JSON parser and generator in pure Elixir.",
               licenses: ["Apache-2.0"],
               links: %{
                 "docs" => "https://hexdocs.pm/jason/1.4.4/",
                 "github" => "https://github.com/michalmuskala/jason",
                 "homepage" => "https://hex.pm/packages/jason/1.4.4"
               },
               source_url: "https://github.com/michalmuskala/jason"
             } =
               SCM.enhance_metadata(:jason, dependency)
    end

    test "attempts to fetch when some metadata keys are missing" do
      dependency = %{
        licenses: ["MIT"],
        version: "1.4.4"
      }

      %{
        description: "A blazing fast JSON parser and generator in pure Elixir.",
        licenses: ["Apache-2.0"],
        links: %{
          "docs" => "https://hexdocs.pm/jason/1.4.4/",
          "github" => "https://github.com/michalmuskala/jason",
          "homepage" => "https://hex.pm/packages/jason/1.4.4"
        },
        source_url: "https://github.com/michalmuskala/jason"
      } =
        SCM.enhance_metadata(:jason, dependency)
    end
  end
end
