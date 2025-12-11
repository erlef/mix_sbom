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

      bom = CycloneDX.bom_for_components(dependencies, version: schema)

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

  test "classification option sets root component type" do
    components = Fetcher.fetch()

    # Default classification
    bom_default = CycloneDX.bom_for_components(components)
    assert bom_default.metadata.component.type == :CLASSIFICATION_APPLICATION

    # Custom classification
    bom_framework = CycloneDX.bom_for_components(components, classification: :CLASSIFICATION_FRAMEWORK)
    assert bom_framework.metadata.component.type == :CLASSIFICATION_FRAMEWORK

    # Dependencies remain LIBRARY
    Enum.each(bom_framework.components, fn comp ->
      assert comp.type == :CLASSIFICATION_LIBRARY
    end)
  end

  property "XML round-trip preserves BOM structure" do
    check all(
            raw_dependencies <- DependencyGenerators.dependency_map(),
            schema <- member_of(["1.7", "1.6", "1.5", "1.4", "1.3"])
          ) do
      atom_dependencies =
        Map.new(raw_dependencies, fn {app_string, dep} ->
          {String.to_existing_atom(app_string), dep}
        end)

      dependencies = Fetcher.transform_all(atom_dependencies)

      # Generate original BOM
      original_bom = CycloneDX.bom_for_components(dependencies, version: schema)

      # Encode to XML
      xml_string = CycloneDX.encode(original_bom, :xml)

      # Decode from XML
      decoded_bom = CycloneDX.decode(xml_string, :xml)

      # Compare canonicalized versions
      assert cannonicalize_bom(original_bom) == cannonicalize_bom(decoded_bom)
    end
  end

  property "JSON round-trip preserves BOM structure" do
    check all(
            raw_dependencies <- DependencyGenerators.dependency_map(),
            schema <- member_of(["1.7", "1.6", "1.5", "1.4", "1.3"])
          ) do
      atom_dependencies =
        Map.new(raw_dependencies, fn {app_string, dep} ->
          {String.to_existing_atom(app_string), dep}
        end)

      dependencies = Fetcher.transform_all(atom_dependencies)

      # Generate original BOM
      original_bom = CycloneDX.bom_for_components(dependencies, version: schema)

      # Encode to JSON
      json_string = CycloneDX.encode(original_bom, :json)

      # Decode from JSON
      decoded_bom = CycloneDX.decode(json_string, :json)

      # Compare canonicalized versions
      assert cannonicalize_bom(original_bom) == cannonicalize_bom(decoded_bom)
    end
  end

  property "Protobuf round-trip preserves BOM structure" do
    check all(
            raw_dependencies <- DependencyGenerators.dependency_map(),
            schema <- member_of(["1.7", "1.6", "1.5", "1.4", "1.3"])
          ) do
      atom_dependencies =
        Map.new(raw_dependencies, fn {app_string, dep} ->
          {String.to_existing_atom(app_string), dep}
        end)

      dependencies = Fetcher.transform_all(atom_dependencies)

      # Generate original BOM
      original_bom = CycloneDX.bom_for_components(dependencies, version: schema)

      # Encode to Protobuf
      protobuf_binary = CycloneDX.encode(original_bom, :protobuf)

      # Decode from protobuf
      decoded_bom = CycloneDX.decode(protobuf_binary, :protobuf)

      # Compare canonicalized versions
      assert cannonicalize_bom(original_bom) == cannonicalize_bom(decoded_bom)
    end
  end

  describe "pretty JSON encoding (OTP-dependent)" do
    @tag :tmp_dir
    test "behaves correctly on this OTP", %{tmp_dir: tmp_dir} do
      [raw_dependencies] = Enum.take(DependencyGenerators.dependency_map(), 1)

      atom_dependencies =
        Map.new(raw_dependencies, fn {app_string, dep} ->
          {String.to_existing_atom(app_string), dep}
        end)

      dependencies = Fetcher.transform_all(atom_dependencies)

      bom = CycloneDX.bom_for_components(dependencies)

      pretty = CycloneDX.encode(bom, :json, true)

      pretty_path = Path.join(tmp_dir, "bom_pretty.json")
      File.write!(pretty_path, pretty)
      assert_valid_cyclonedx_bom(pretty_path, :json)

      assert pretty |> IO.iodata_to_binary() |> String.split("\n") |> length() > 1
    end
  end

  describe "Pretty XML encoding" do
    case Code.ensure_loaded(:xmerl_xml_indent) do
      {:module, :xmerl_xml_indent} ->
        @tag :tmp_dir
        test "prints XML", %{tmp_dir: tmp_dir} do
          [raw_dependencies] = Enum.take(DependencyGenerators.dependency_map(), 1)

          atom_dependencies =
            Map.new(raw_dependencies, fn {app_string, dep} ->
              {String.to_existing_atom(app_string), dep}
            end)

          dependencies = Fetcher.transform_all(atom_dependencies)

          bom = CycloneDX.bom_for_components(dependencies)

          pretty = CycloneDX.encode(bom, :xml, true)

          pretty_path = Path.join(tmp_dir, "bom_pretty.xml")
          File.write!(pretty_path, pretty)
          assert_valid_cyclonedx_bom(pretty_path, :xml)

          assert Regex.match?(~r/\n\s+</, pretty)
          assert pretty |> String.split("\n") |> length() > 1
        end

      {:error, _reason} ->
        @tag :tmp_dir
        test "errors when not available" do
          components = Fetcher.fetch()
          bom = CycloneDX.bom_for_components(components)

          # Pretty not available: we expect your helpful RuntimeError
          assert_raise RuntimeError,
                       ~r/Pretty XML formatting is not available/,
                       fn ->
                         CycloneDX.encode(bom, :xml, true)
                       end
        end
    end
  end

  describe "bom_ref generation" do
    test "generates readable bom_ref for components" do
      components = Fetcher.fetch()
      bom = CycloneDX.bom_for_components(components)

      Enum.each(bom.components, fn comp ->
        assert String.starts_with?(comp.bom_ref, "otp:component:")

        cond do
          String.contains?(comp.purl || "", "pkg:hex/") ->
            assert String.contains?(comp.bom_ref, ":hex:")

          String.contains?(comp.purl || "", "pkg:otp/") ->
            assert String.contains?(comp.bom_ref, ":otp:")

          String.contains?(comp.purl || "", "pkg:github/") ->
            assert String.contains?(comp.bom_ref, ":github:")

          String.contains?(comp.purl || "", "pkg:generic/") ->
            assert String.contains?(comp.bom_ref, ":generic:")

          true ->
            :ok
        end
      end)
    end
  end
end
