# SPDX-License-Identifier: BSD-3-Clause
# SPDX-FileCopyrightText: 2025 Erlang Ecosystem Foundation

defmodule SBoM.CycloneDX.JSON.DecodableTest do
  use ExUnit.Case, async: true

  alias SBoM.CycloneDX.JSON.Decodable
  alias SBoM.CycloneDX.JSON.Encodable
  alias SBoM.CycloneDX.V17.Bom
  alias SBoM.CycloneDX.V17.Component
  alias SBoM.CycloneDX.V17.Dependency
  alias SBoM.CycloneDX.V17.ExternalReference
  alias SBoM.CycloneDX.V17.Hash

  describe "round-trip compatibility" do
    test "Component encoding and decoding" do
      component = %Component{
        type: :CLASSIFICATION_LIBRARY,
        name: "test-component",
        version: "1.0.0",
        bom_ref: "test-ref",
        scope: :SCOPE_REQUIRED
      }

      # Encode to JSON-compatible map
      encoded = Encodable.to_encodable(component)

      # Decode back to struct
      decoded = Decodable.from_json_data(%Component{}, encoded)

      assert decoded == component
    end

    test "Hash encoding and decoding" do
      hash = %Hash{
        alg: :HASH_ALG_SHA_256,
        value: "abc123def456"
      }

      encoded = Encodable.to_encodable(hash)
      decoded = Decodable.from_json_data(%Hash{}, encoded)

      assert decoded == hash
    end

    test "ExternalReference encoding and decoding" do
      ext_ref = %ExternalReference{
        type: :EXTERNAL_REFERENCE_TYPE_WEBSITE,
        url: "https://example.com"
      }

      encoded = Encodable.to_encodable(ext_ref)
      decoded = Decodable.from_json_data(%ExternalReference{}, encoded)

      assert decoded == ext_ref
    end

    test "Dependency encoding and decoding" do
      dependency = %Dependency{
        ref: "main-component"
      }

      encoded = Encodable.to_encodable(dependency)
      decoded = Decodable.from_json_data(%Dependency{}, encoded)

      assert decoded == dependency
    end

    test "Bom encoding and decoding" do
      bom = %Bom{
        spec_version: "1.7",
        version: 1
      }

      encoded = Encodable.to_encodable(bom)
      decoded = Decodable.from_json_data(%Bom{}, encoded)

      assert decoded == bom
    end
  end

  describe "field transformations" do
    test "Component bom-ref transformation" do
      json_data = %{
        "type" => "library",
        "name" => "test-component",
        "version" => "1.0.0",
        "bom-ref" => "test-ref",
        "scope" => "required"
      }

      decoded = Decodable.from_json_data(%Component{}, json_data)

      assert decoded.bom_ref == "test-ref"
      assert decoded.type == :CLASSIFICATION_LIBRARY
      assert decoded.scope == :SCOPE_REQUIRED
    end

    test "Hash content to value transformation" do
      json_data = %{
        "alg" => "SHA-256",
        "content" => "abc123def456"
      }

      decoded = Decodable.from_json_data(%Hash{}, json_data)

      assert decoded.value == "abc123def456"
      assert decoded.alg == :HASH_ALG_SHA_256
    end

    test "Dependency dependsOn transformation" do
      json_data = %{
        "ref" => "main-component",
        "dependsOn" => ["dep1", "dep2"]
      }

      decoded = Decodable.from_json_data(%Dependency{}, json_data)

      assert decoded.ref == "main-component"
      # Should transform dependsOn array to dependencies list of structs
      assert length(decoded.dependencies) == 2
      assert Enum.at(decoded.dependencies, 0).ref == "dep1"
      assert Enum.at(decoded.dependencies, 1).ref == "dep2"
    end

    test "Bom bomFormat removal" do
      json_data = %{
        "bomFormat" => "CycloneDX",
        "specVersion" => "1.7",
        "version" => 1
      }

      decoded = Decodable.from_json_data(%Bom{}, json_data)

      assert decoded.spec_version == "1.7"
      assert decoded.version == 1
      # bomFormat should be ignored as it's not part of the struct
    end
  end
end
