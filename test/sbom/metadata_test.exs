# SPDX-License-Identifier: BSD-3-Clause
# SPDX-FileCopyrightText: 2025 Erlang Ecosystem Foundation

defmodule SBoM.MetadataTest do
  use ExUnit.Case, async: true

  alias SBoM.Metadata

  doctest Metadata

  describe "keys/0" do
    test "returns the list of metadata keys" do
      assert Metadata.keys() == [:licenses, :source_url, :links, :description]
      assert is_list(Metadata.keys())
      assert Enum.all?(Metadata.keys(), &is_atom/1)
    end

    test "keys match the metadata type definition" do
      keys = Metadata.keys()

      metadata = %{
        licenses: ["MIT"],
        source_url: "https://example.com",
        links: %{"homepage" => "https://example.com"},
        description: "A test package"
      }

      # All keys should be present in the metadata map
      assert Enum.all?(keys, &Map.has_key?(metadata, &1))
    end
  end
end
