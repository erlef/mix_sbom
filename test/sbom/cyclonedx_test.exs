# SPDX-License-Identifier: BSD-3-Clause
# SPDX-FileCopyrightText: 2025 Erlang Ecosystem Foundation

# credo:disable-for-this-file Credo.Check.Design.DuplicatedCode
defmodule SBoM.CycloneDXTest do
  use SBoM.FixtureCase, async: true
  use SBoM.ValidatorCase, async: true
  use ExUnitProperties

  alias SBoM.CycloneDX
  alias SBoM.DependencyGenerators
  alias SBoM.Fetcher

  doctest CycloneDX

  @tag :tmp_dir
  property "generates valid SBOM files in each format", %{tmp_dir: tmp_dir} do
    check all(
            raw_dependencies <- DependencyGenerators.dependency_map(),
            # TODO: Add "1.7" when CycloneDX CLI supports it
            schema <- member_of(["1.6", "1.5", "1.4", "1.3"]),
            format <- member_of([:json, :xml, :protobuf])
          ) do
      atom_dependencies =
        Map.new(raw_dependencies, fn {app_string, dep} ->
          {String.to_existing_atom(app_string), dep}
        end)

      dependencies = Fetcher.transform_all(atom_dependencies)

      bom = CycloneDX.bom(dependencies, version: schema)

      encoded_bom = CycloneDX.encode(bom, format)

      filename = "test_bom_#{:erlang.phash2({dependencies, schema, format})}"

      file_path =
        case format do
          :json -> Path.join(tmp_dir, "#{filename}.cdx.json")
          :xml -> Path.join(tmp_dir, "#{filename}.cdx.xml")
          :protobuf -> Path.join(tmp_dir, "#{filename}.cdx")
        end

      File.write!(file_path, encoded_bom)

      assert_valid_cyclonedx_bom(file_path, format)
    end
  end

  @tag :tmp_dir
  property "encodes equivalent data across all formats", %{tmp_dir: tmp_dir} do
    check all(
            raw_dependencies <- DependencyGenerators.dependency_map(),
            # TODO: Add "1.7" when CycloneDX CLI supports it
            schema <- member_of(["1.6", "1.5", "1.4", "1.3"])
          ) do
      atom_dependencies =
        Map.new(raw_dependencies, fn {app_string, dep} ->
          {String.to_existing_atom(app_string), dep}
        end)

      dependencies = Fetcher.transform_all(atom_dependencies)

      bom = CycloneDX.bom(dependencies, version: schema)

      json_bom = CycloneDX.encode(bom, :json)
      xml_bom = CycloneDX.encode(bom, :xml)
      protobuf_bom = CycloneDX.encode(bom, :protobuf)

      base_filename = "test_bom_#{:erlang.phash2({dependencies, schema})}"
      json_path = Path.join(tmp_dir, "#{base_filename}.cdx.json")
      xml_path = Path.join(tmp_dir, "#{base_filename}.cdx.xml")
      protobuf_path = Path.join(tmp_dir, "#{base_filename}.cdx")

      File.write!(json_path, json_bom)
      File.write!(xml_path, xml_bom)
      File.write!(protobuf_path, protobuf_bom)

      json_to_protobuf_path = Path.join(tmp_dir, "#{base_filename}_json.cdx")
      xml_to_protobuf_path = Path.join(tmp_dir, "#{base_filename}_xml.cdx")

      # Convert JSON and XML to Protobuf for canonical comparison
      convert_cyclonedx_bom(json_path, json_to_protobuf_path, :json, :protobuf)
      convert_cyclonedx_bom(xml_path, xml_to_protobuf_path, :xml, :protobuf)

      # Decode converted protobuf files and compare the structures
      json_converted_protobuf_binary = File.read!(json_to_protobuf_path)
      xml_converted_protobuf_binary = File.read!(xml_to_protobuf_path)

      # Get the protobuf module from the BOM struct
      %bom_struct{} = bom
      json_decoded_bom = bom_struct.decode(json_converted_protobuf_binary)
      xml_decoded_bom = bom_struct.decode(xml_converted_protobuf_binary)

      assert cannonicalize_bom(bom) == cannonicalize_bom(json_decoded_bom)
      assert cannonicalize_bom(bom) == cannonicalize_bom(xml_decoded_bom)
    end
  end

  test "classification option sets root component type" do
    components = Fetcher.fetch()

    # Default classification
    bom_default = CycloneDX.bom(components)
    assert bom_default.metadata.component.type == :CLASSIFICATION_APPLICATION

    # Custom classification
    bom_framework = CycloneDX.bom(components, classification: :CLASSIFICATION_FRAMEWORK)
    assert bom_framework.metadata.component.type == :CLASSIFICATION_FRAMEWORK

    # Dependencies remain LIBRARY
    Enum.each(bom_framework.components, fn comp ->
      assert comp.type == :CLASSIFICATION_LIBRARY
    end)
  end
end
