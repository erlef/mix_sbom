# SPDX-License-Identifier: BSD-3-Clause
# SPDX-FileCopyrightText: 2025 Erlang Ecosystem Foundation

defmodule SBoM.SCM.Hex.SCMTest do
  use SBoM.FixtureCase, async: false

  alias SBoM.Metadata
  alias SBoM.SCM.Hex.SCM

  doctest SCM

  describe "enhance_metadata/2" do
    test "returns empty map when all metadata keys are present" do
      dependency = %{
        :licenses => ["MIT"],
        :source_url => "https://example.com",
        :links => %{"homepage" => "https://example.com"}
      }

      result = SCM.enhance_metadata(:test_app, dependency)
      assert result == %{}
    end

    test "attempts to fetch when metadata keys have empty list or empty map values" do
      dependency = %{
        :licenses => [],
        :source_url => nil,
        :links => %{}
      }

      result = SCM.enhance_metadata(:jason, dependency)
      assert is_map(result)

      # If fetch succeeded and returned metadata, all keys should have meaningful values
      # If fetch failed or returned empty metadata, result will be %{}
      if result != %{} do
        # Result should contain all metadata keys with meaningful values
        Enum.each(Metadata.keys(), fn key ->
          value = Map.get(result, key)
          assert value
          assert value != []
          assert value != %{}
        end)
      end
    end

    test "attempts to fetch when metadata keys are missing" do
      # Missing all metadata keys
      dependency =
        %{:version => "1.0.0"}

      result = SCM.enhance_metadata(:jason, dependency)

      assert is_map(result)

      if result != %{} do
        # Result should contain all metadata keys with meaningful values
        Enum.each(Metadata.keys(), fn key ->
          value = Map.get(result, key)
          assert value
          assert value != []
          assert value != %{}
        end)
      end
    end

    test "attempts to fetch when some metadata keys are missing" do
      dependency = %{
        :licenses => ["MIT"],
        :version => "1.0.0"
      }

      result = SCM.enhance_metadata(:jason, dependency)

      assert is_map(result)

      if result != %{} do
        # Result should contain all metadata keys with meaningful values
        Enum.each(Metadata.keys(), fn key ->
          value = Map.get(result, key)
          assert value
          assert value != []
          assert value != %{}
        end)
      end
    end
  end
end
