# SPDX-License-Identifier: BSD-3-Clause
# SPDX-FileCopyrightText: 2025 Erlang Ecosystem Foundation

# credo:disable-for-this-file Credo.Check.Design.DuplicatedCode
defmodule Version.Requirement.VersTest do
  use ExUnit.Case, async: true
  use ExUnitProperties

  alias Version.Requirement.Vers

  doctest Vers

  describe inspect(&Vers.to_vers/2) do
    test "handles string requirements" do
      assert Vers.to_vers("~> 1.2.3") == {:ok, "vers:elixir/>=1.2.3|<1.3.0-0"}
      assert Vers.to_vers(">= 1.0.0 and < 2.0.0") == {:ok, "vers:elixir/>=1.0.0|<2.0.0"}
    end

    test "handles Version.Requirement structs" do
      requirement = Version.parse_requirement!("~> 1.2.3")
      assert Vers.to_vers(requirement) == {:ok, "vers:elixir/>=1.2.3|<1.3.0-0"}
    end

    test "handles custom type parameter" do
      assert Vers.to_vers("== 1.0.0", "npm") == {:ok, "vers:npm/1.0.0"}
      assert Vers.to_vers("~> 1.2.3", "go") == {:ok, "vers:go/>=1.2.3|<1.3.0-0"}
    end

    test "returns error for invalid string requirements" do
      assert Vers.to_vers("invalid") == :error
    end

    test "handles single version requirements" do
      assert Vers.to_vers("== 1.2.3") == {:ok, "vers:elixir/1.2.3"}
      assert Vers.to_vers("1.2.3") == {:ok, "vers:elixir/1.2.3"}
    end

    test "handles open-ended ranges" do
      assert Vers.to_vers(">= 1.0.0") == {:ok, "vers:elixir/>=1.0.0"}
      assert Vers.to_vers("> 2.0.0") == {:ok, "vers:elixir/>2.0.0"}
      assert Vers.to_vers("<= 3.0.0") == {:ok, "vers:elixir/<=3.0.0"}
      assert Vers.to_vers("< 4.0.0") == {:ok, "vers:elixir/<4.0.0"}
    end

    test "handles pre-release and build metadata" do
      assert Vers.to_vers("== 1.2.3-alpha.1+build.123") ==
               {:ok, "vers:elixir/1.2.3-alpha.1+build.123"}
    end

    test "handles complex version requirements" do
      assert Vers.to_vers(">= 1.2.3 and < 2.0.0 or == 3.0.0") ==
               {:ok, "vers:elixir/>=1.2.3|<2.0.0|3.0.0"}
    end
  end

  describe "inequality pattern round-trip" do
    test "!= 1.2.1 should maintain semantic equivalence with 1.2.1+A" do
      Code.with_diagnostics(fn ->
        {:ok, vers_string} = Vers.to_vers("!= 1.2.1")
        {:ok, {parsed_req, "elixir"}} = Vers.from_vers(vers_string)

        req = "!= 1.2.1"
        original_req = Version.parse_requirement!(req)
        test_version = Version.parse!("1.2.1+A")

        original_match = Version.match?(test_version, original_req)

        parsed_match =
          case parsed_req do
            :any -> true
            req -> Version.match?(test_version, req)
          end

        assert original_match == parsed_match,
               "Semantic equivalence failed: original=#{original_match}, parsed=#{parsed_match}"

        refute original_match, "Should not match version with build metadata"
      end)
    end
  end

  describe inspect(&Vers.from_vers/1) do
    test "returns error for invalid format" do
      assert Vers.from_vers("invalid") == :error
      assert Vers.from_vers("vers:") == :error
      assert Vers.from_vers("vers:elixir") == :error
      assert Vers.from_vers("notvers:elixir/>=1.0.0") == :error
    end

    test "returns error for empty constraints" do
      assert Vers.from_vers("vers:elixir/") == :error
    end

    test "handles universal constraint" do
      assert {:ok, {req, "elixir"}} = Vers.from_vers("vers:elixir/*")
      assert to_string(req) == ">= 0.0.0-0"
      assert "0.0.0-0" |> Version.parse!() |> Version.match?(req, allow_pre: true)
      assert "1.2.3" |> Version.parse!() |> Version.match?(req, allow_pre: true)

      assert {:ok, {req, "npm"}} = Vers.from_vers("vers:npm/*")
      assert to_string(req) == ">= 0.0.0-0"
    end

    test "handles single version constraints" do
      assert {:ok, {req, "elixir"}} = Vers.from_vers("vers:elixir/1.2.3")
      assert "1.2.3" |> Version.parse!() |> Version.match?(req)
      refute "1.2.4" |> Version.parse!() |> Version.match?(req)
    end

    test "handles open-ended constraints" do
      assert {:ok, {req, "elixir"}} = Vers.from_vers("vers:elixir/>=1.0.0")
      assert "1.0.0" |> Version.parse!() |> Version.match?(req)
      assert "2.0.0" |> Version.parse!() |> Version.match?(req)
      refute "0.9.0" |> Version.parse!() |> Version.match?(req)

      assert {:ok, {req, "elixir"}} = Vers.from_vers("vers:elixir/>2.0.0")
      assert "2.1.0" |> Version.parse!() |> Version.match?(req)
      refute "2.0.0" |> Version.parse!() |> Version.match?(req)

      assert {:ok, {req, "elixir"}} = Vers.from_vers("vers:elixir/<=3.0.0")
      assert "3.0.0" |> Version.parse!() |> Version.match?(req)
      assert "2.9.0" |> Version.parse!() |> Version.match?(req)
      refute "3.1.0" |> Version.parse!() |> Version.match?(req)

      assert {:ok, {req, "elixir"}} = Vers.from_vers("vers:elixir/<4.0.0")
      assert "3.9.0" |> Version.parse!() |> Version.match?(req)
      refute "4.0.0" |> Version.parse!() |> Version.match?(req)
    end

    test "handles bounded ranges" do
      assert {:ok, {req, "elixir"}} = Vers.from_vers("vers:elixir/>=1.0.0|<2.0.0")
      assert "1.0.0" |> Version.parse!() |> Version.match?(req)
      assert "1.9.9" |> Version.parse!() |> Version.match?(req)
      refute "0.9.0" |> Version.parse!() |> Version.match?(req)
      refute "2.0.0" |> Version.parse!() |> Version.match?(req)
    end

    test "handles pre-release and build metadata" do
      assert {:ok, {req, "elixir"}} = Vers.from_vers("vers:elixir/1.2.3-alpha.1+build.123")
      assert "1.2.3-alpha.1+build.123" |> Version.parse!() |> Version.match?(req)
      refute "1.2.3" |> Version.parse!() |> Version.match?(req)
    end

    test "keeps inclusive bounds adjacent to another constraint" do
      assert {:ok, {req, "elixir"}} = Vers.from_vers("vers:elixir/<1.0.0|>=1.0.0")
      assert to_string(req) == "< 1.0.0 or >= 1.0.0"
      assert "1.0.0" |> Version.parse!() |> Version.match?(req)

      assert {:ok, {req, "elixir"}} = Vers.from_vers("vers:elixir/<=1.0.0|>1.0.0")
      assert "1.0.0" |> Version.parse!() |> Version.match?(req)
    end

    test "handles different types" do
      assert {:ok, {req, "npm"}} = Vers.from_vers("vers:npm/>=1.0.0")
      assert "1.0.0" |> Version.parse!() |> Version.match?(req)

      assert {:ok, {req, "go"}} = Vers.from_vers("vers:go/1.2.3")
      assert "1.2.3" |> Version.parse!() |> Version.match?(req)
    end

    test "returns error for invalid constraints" do
      assert Vers.from_vers("vers:elixir/invalid") == :error
      assert Vers.from_vers("vers:elixir/~1.0.0") == :error
    end

    test "handles multiple disjoint ranges" do
      assert {:ok, {req, "elixir"}} = Vers.from_vers("vers:elixir/1.0.0|2.0.0")
      assert "1.0.0" |> Version.parse!() |> Version.match?(req)
      assert "2.0.0" |> Version.parse!() |> Version.match?(req)
      refute "1.5.0" |> Version.parse!() |> Version.match?(req)
    end

    test "handles common ~> pattern" do
      assert {:ok, {normal_req, "elixir"}} = Vers.from_vers("vers:elixir/>=1.2.3|<1.3.0|>=1.4.0|<2.0.0")
      assert to_string(normal_req) == ">= 1.2.3 and < 1.3.0 or >= 1.4.0 and < 2.0.0"

      assert "1.3.0-beta.1" |> Version.parse!() |> Version.match?(normal_req, allow_pre: true)

      assert {:ok, {req, "elixir"}} = Vers.from_vers("vers:elixir/>=1.2.3|<1.3.0-0|>=1.4.0|<2.0.0-0")
      assert to_string(req) == "~> 1.2.3 or ~> 1.4"

      refute "1.3.0-beta.1" |> Version.parse!() |> Version.match?(req, allow_pre: true)
    end
  end

  describe "property-based testing" do
    property "to_vers and from_vers semantic equivalence" do
      check all(
              requirement <- VersionGenerator.version_requirement(),
              test_version <- VersionGenerator.full_semver(),
              allow_pre <- StreamData.boolean()
            ) do
        ExUnit.CaptureIO.capture_io(:stderr, fn ->
          case Vers.to_vers(requirement) do
            {:ok, vers_string} ->
              assert {:ok, {parsed_req, "elixir"}} = Vers.from_vers(vers_string)
              # Test semantic equivalence: both should match test_version identically
              original_requirement = Version.parse_requirement!(requirement)
              test_parsed_version = Version.parse!(test_version)

              original_match = Version.match?(test_parsed_version, original_requirement, allow_pre: allow_pre)
              parsed_match = Version.match?(test_parsed_version, parsed_req, allow_pre: allow_pre)

              # Requirements that differ only in the comparators used to spell
              # them out share a vers string, so `from_vers/1` cannot recover
              # which spelling was written. Under `allow_pre: false` the
              # spellings still match differently, because a comparator only
              # admits pre-releases when it names one itself:
              #
              #   * `!= x` admits them, the `< x or > x` it expands to does not
              #   * the universal `>= 0.0.0-0` admits them, a tautology spelled
              #     with plain comparators does not
              #
              # Only their shared `allow_pre: true` meaning is asserted.
              skip? =
                not allow_pre and test_parsed_version.pre != [] and
                  (String.contains?(requirement, "!=") or to_string(parsed_req) == ">= 0.0.0-0")

              assert original_match == parsed_match or skip?,
                     "Semantic equivalence failed for requirement #{requirement} with test version #{test_version}"

            :error ->
              # Skip if conversion failed
              :ok
          end
        end)
      end
    end
  end
end
