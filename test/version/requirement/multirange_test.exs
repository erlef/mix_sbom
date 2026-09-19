# SPDX-License-Identifier: BSD-3-Clause
# SPDX-FileCopyrightText: 2025 Erlang Ecosystem Foundation

# credo:disable-for-this-file Credo.Check.Design.DuplicatedCode
defmodule Version.Requirement.MultirangeTest do
  use ExUnit.Case, async: true
  use ExUnitProperties

  alias Version.Requirement.Multirange

  describe inspect(&Multirange.to_multi_range/1) do
    test "converts a single version to a multi-range" do
      assert Multirange.to_multi_range("1.2.3") ==
               {:ok,
                [
                  {{:including, {1, 2, 3, [], []}}, {:including, {1, 2, 3, [], []}}}
                ]}
    end

    test "converts a version range to a multi-range" do
      assert "~> 1.2.3"
             |> Version.parse_requirement!()
             |> Multirange.to_multi_range() ==
               {:ok,
                [
                  {{:including, {1, 2, 3, [], []}}, {:excluding, {1, 3, 0, [0], nil}}}
                ]}
    end

    test "converts a complex version requirement to a multi-range" do
      assert Multirange.to_multi_range(">= 1.2.3 and < 2.0.0 or == 3.0.0") ==
               {:ok,
                [
                  {{:including, {1, 2, 3, [], []}}, {:excluding, {2, 0, 0, [], []}}},
                  {{:including, {3, 0, 0, [], []}}, {:including, {3, 0, 0, [], []}}}
                ]}
    end

    test "returns error for invalid version" do
      assert Multirange.to_multi_range("invalid") == :error
    end
  end

  describe inspect(&Multirange.union/2) do
    test "merges overlapping ranges" do
      left = [{{:including, {1, 0, 0, [], []}}, {:including, {1, 5, 0, [], []}}}]
      right = [{{:including, {1, 3, 0, [], []}}, {:including, {2, 0, 0, [], []}}}]

      assert Multirange.union(left, right) == [
               {{:including, {1, 0, 0, [], []}}, {:including, {2, 0, 0, [], []}}}
             ]
    end

    test "keeps separate non-overlapping ranges" do
      left = [{{:including, {1, 0, 0, [], []}}, {:including, {1, 5, 0, [], []}}}]
      right = [{{:including, {2, 0, 0, [], []}}, {:including, {3, 0, 0, [], []}}}]

      assert Multirange.union(left, right) == [
               {{:including, {1, 0, 0, [], []}}, {:including, {1, 5, 0, [], []}}},
               {{:including, {2, 0, 0, [], []}}, {:including, {3, 0, 0, [], []}}}
             ]
    end

    test "handles empty lists" do
      range = [{{:including, {1, 0, 0, [], []}}, {:including, {2, 0, 0, [], []}}}]

      assert Multirange.union([], range) == range
      assert Multirange.union(range, []) == range
      assert Multirange.union([], []) == []
    end
  end

  describe inspect(&Multirange.intersect/2) do
    test "finds intersection of overlapping ranges" do
      left = [{{:including, {1, 0, 0, [], []}}, {:including, {2, 0, 0, [], []}}}]
      right = [{{:including, {1, 5, 0, [], []}}, {:including, {3, 0, 0, [], []}}}]

      assert Multirange.intersect(left, right) == [
               {{:including, {1, 5, 0, [], []}}, {:including, {2, 0, 0, [], []}}}
             ]
    end

    test "returns empty for non-overlapping ranges" do
      left = [{{:including, {1, 0, 0, [], []}}, {:including, {1, 5, 0, [], []}}}]
      right = [{{:including, {2, 0, 0, [], []}}, {:including, {3, 0, 0, [], []}}}]

      assert Multirange.intersect(left, right) == []
    end

    test "handles empty lists" do
      range = [{{:including, {1, 0, 0, [], []}}, {:including, {2, 0, 0, [], []}}}]

      assert Multirange.intersect([], range) == []
      assert Multirange.intersect(range, []) == []
      assert Multirange.intersect([], []) == []
    end

    test "handles inclusion/exclusion boundaries" do
      left = [{{:including, {1, 0, 0, [], []}}, {:including, {2, 0, 0, [], []}}}]
      right = [{{:excluding, {2, 0, 0, [], []}}, {:including, {3, 0, 0, [], []}}}]

      assert Multirange.intersect(left, right) == []
    end

    test "handles bounds without build metadata" do
      # `~>` builds its upper bound with `nil` rather than `[]` build metadata.
      assert Multirange.to_multi_range("~> 1.2.3 and ~> 1.2.3") ==
               {:ok, [{{:including, {1, 2, 3, [], []}}, {:excluding, {1, 3, 0, [0], nil}}}]}

      range = [{{:including, {1, 0, 0, [], nil}}, {:excluding, {2, 0, 0, [], nil}}}]
      assert Multirange.intersect(range, range) == range
    end
  end

  describe "regression tests" do
    test "version 1.0.0 with requirement < 1.0.0 should have empty intersection" do
      version = "1.0.0"
      requirement = "< 1.0.0"

      # Test Elixir behavior
      parsed_version = Version.parse!(version)
      parsed_requirement = Version.parse_requirement!(requirement)
      elixir_match = Version.match?(parsed_version, parsed_requirement)

      # Test our behavior
      {:ok, requirement_multi_range} = Multirange.to_multi_range(requirement)
      {:ok, version_multi_range} = Multirange.to_multi_range("== #{version}")
      intersection = Multirange.intersect(requirement_multi_range, version_multi_range)

      refute elixir_match
      assert intersection == []
    end

    test "version with build metadata should match requirement without build metadata" do
      version = "1.1.0+sha.C"
      requirement = "== 1.1.0"

      # Test Elixir behavior
      parsed_version = Version.parse!(version)
      parsed_requirement = Version.parse_requirement!(requirement)
      elixir_match = Version.match?(parsed_version, parsed_requirement)

      # Test our behavior
      {:ok, requirement_multi_range} = Multirange.to_multi_range(requirement)
      {:ok, version_multi_range} = Multirange.to_multi_range("== #{version}")
      intersection = Multirange.intersect(requirement_multi_range, version_multi_range)

      assert elixir_match
      assert intersection == version_multi_range
    end
  end

  describe inspect(&Multirange.to_requirement/1) do
    test "returns an unsatisfiable requirement for empty multi-range" do
      assert {:ok, req} = Multirange.to_requirement([])
      assert to_string(req) == "< 0.0.0-0"
      refute "0.0.0-0" |> Version.parse!() |> Version.match?(req, allow_pre: true)
      refute "1.2.3" |> Version.parse!() |> Version.match?(req, allow_pre: true)
    end

    test "returns a universal requirement for universal range" do
      assert {:ok, req} = Multirange.to_requirement([{:min, :max}])
      assert to_string(req) == ">= 0.0.0-0"
      assert "0.0.0-0" |> Version.parse!() |> Version.match?(req, allow_pre: true)
      assert "1.2.3" |> Version.parse!() |> Version.match?(req, allow_pre: true)
    end

    test "handles single version ranges" do
      assert {:ok, req} = Multirange.to_requirement([{{:including, {1, 2, 3, [], []}}, {:including, {1, 2, 3, [], []}}}])
      assert "1.2.3" |> Version.parse!() |> Version.match?(req)
      refute "1.2.4" |> Version.parse!() |> Version.match?(req)
    end

    test "handles open-ended ranges" do
      assert {:ok, req} = Multirange.to_requirement([{{:including, {1, 0, 0, [], []}}, :max}])
      assert "1.0.0" |> Version.parse!() |> Version.match?(req)
      assert "2.0.0" |> Version.parse!() |> Version.match?(req)
      refute "0.9.0" |> Version.parse!() |> Version.match?(req)

      assert {:ok, req} = Multirange.to_requirement([{:min, {:excluding, {2, 0, 0, [], []}}}])
      assert "1.9.0" |> Version.parse!() |> Version.match?(req)
      refute "2.0.0" |> Version.parse!() |> Version.match?(req)
      refute "2.1.0" |> Version.parse!() |> Version.match?(req)
    end

    test "handles bounded ranges" do
      assert {:ok, req} = Multirange.to_requirement([{{:including, {1, 0, 0, [], []}}, {:excluding, {2, 0, 0, [], []}}}])
      assert "1.0.0" |> Version.parse!() |> Version.match?(req)
      assert "1.9.9" |> Version.parse!() |> Version.match?(req)
      refute "0.9.0" |> Version.parse!() |> Version.match?(req)
      refute "2.0.0" |> Version.parse!() |> Version.match?(req)
    end

    test "handles multiple disjoint ranges" do
      multi_range = [
        {{:including, {1, 0, 0, [], []}}, {:including, {1, 0, 0, [], []}}},
        {{:including, {2, 0, 0, [], []}}, {:including, {3, 0, 0, [], []}}}
      ]

      assert {:ok, req} = Multirange.to_requirement(multi_range)
      assert "1.0.0" |> Version.parse!() |> Version.match?(req)
      assert "2.5.0" |> Version.parse!() |> Version.match?(req)
      assert "3.0.0" |> Version.parse!() |> Version.match?(req)
      refute "1.5.0" |> Version.parse!() |> Version.match?(req)
      refute "3.1.0" |> Version.parse!() |> Version.match?(req)
    end

    test "handles pre-release and build metadata" do
      assert {:ok, req} =
               Multirange.to_requirement([
                 {{:including, {1, 2, 3, ["alpha", "1"], ["build", "123"]}},
                  {:including, {1, 2, 3, ["alpha", "1"], ["build", "123"]}}}
               ])

      assert "1.2.3-alpha.1+build.123" |> Version.parse!() |> Version.match?(req)
      refute "1.2.3" |> Version.parse!() |> Version.match?(req)
    end
  end

  describe "property-based testing" do
    property "Multirange.intersect consistency with Version.match?" do
      check all(
              version <- VersionGenerator.full_semver(),
              requirement <- VersionGenerator.version_requirement()
            ) do
        ExUnit.CaptureIO.capture_io(:stderr, fn ->
          parsed_version = Version.parse!(version)
          parsed_requirement = Version.parse_requirement!(requirement)
          elixir_match = Version.match?(parsed_version, parsed_requirement)

          {:ok, requirement_multi_range} = Multirange.to_multi_range(requirement)
          {:ok, version_multi_range} = Multirange.to_multi_range("== #{version}")
          intersection = Multirange.intersect(requirement_multi_range, version_multi_range)

          if elixir_match do
            assert intersection == version_multi_range,
                   "Expected intersection to equal version for #{version} matching #{requirement}"
          else
            assert intersection == [],
                   "Expected empty intersection for #{version} not matching #{requirement}"
          end
        end)
      end
    end

    property "to_requirement and to_multi_range round-trip" do
      check all(
              requirement <- VersionGenerator.version_requirement(),
              test_version <- VersionGenerator.full_semver()
            ) do
        ExUnit.CaptureIO.capture_io(:stderr, fn ->
          assert {:ok, original_multi_range} = Multirange.to_multi_range(requirement)

          case original_multi_range do
            [] ->
              # Skip empty ranges as they cannot be converted to requirements
              :ok

            _non_empty ->
              assert {:ok, parsed} = Multirange.to_requirement(original_multi_range)

              case parsed do
                :any ->
                  # Universal ranges should match any version
                  parsed_version = Version.parse!(test_version)
                  original_requirement = Version.parse_requirement!(requirement)
                  original_match = Version.match?(parsed_version, original_requirement)

                  assert original_match,
                         "Universal range should match any version, but #{test_version} doesn't match original #{requirement}"

                req ->
                  assert {:ok, round_trip_multi_range} = Multirange.to_multi_range(req)

                  # Test semantic equivalence with test version
                  {:ok, version_multi_range} = Multirange.to_multi_range("== #{test_version}")

                  original_intersection = Multirange.intersect(original_multi_range, version_multi_range)
                  round_trip_intersection = Multirange.intersect(round_trip_multi_range, version_multi_range)

                  assert original_intersection == round_trip_intersection,
                         "Round-trip failed for requirement #{requirement} with test version #{test_version}"
              end
          end
        end)
      end
    end
  end
end
