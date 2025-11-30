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

  describe "encode_json with pretty printing error cases" do
    # These tests only run when JSON module is being used (not Jason)
    setup do
      # Check if we're using JSON (not Jason) by attempting a non-pretty encode
      # If it works, we can test the pretty encoding error cases
      try do
        components = Fetcher.fetch()
        bom = CycloneDX.bom(components)
        _result = CycloneDX.encode(bom, :json, false)

        # If we got here, JSON is available. Now check if we can test the error cases
        # Only mock :json, not Code (mocking Code causes VM crashes)
        :meck.new(:json, [:unstick])

        on_exit(fn ->
          try do
            :meck.unload(:json)
          catch
            :error, {:not_mocked, _module} -> :ok
          end
        end)

        {:ok, can_test: true}
      rescue
        _error ->
          # Return a flag indicating we can't test
          {:ok, can_test: false}
      end
    end

    test "raises helpful error when :json.format/2 is not available", %{can_test: can_test} do
      if !can_test, do: flunk("JSON module not available or Jason is being used")

      components = Fetcher.fetch()
      bom = CycloneDX.bom(components)

      # Mock :json.format/2 to raise UndefinedFunctionError
      # Code.ensure_loaded will work normally and return {:module, :json}
      :meck.expect(:json, :format, fn _encodable, _formatter ->
        error = %UndefinedFunctionError{
          module: :json,
          function: :format,
          arity: 2,
          reason: nil,
          message: nil
        }

        raise error
      end)

      assert_raise RuntimeError,
                   ~r/:json\.format\/2 could not be called.*Update to a newer version of Erlang\/OTP/s,
                   fn ->
                     CycloneDX.encode(bom, :json, true)
                   end
    end
  end
end
