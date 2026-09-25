# SPDX-License-Identifier: BSD-3-Clause
# SPDX-FileCopyrightText: 2025 Erlang Ecosystem Foundation
# SPDX-FileCopyrightText: 2025 Stritzinger GmbH

# credo:disable-for-this-file Credo.Check.Design.DuplicatedCode
defmodule SBoM.CycloneDXTest do
  use SBoM.FixtureCase, async: true
  use SBoM.ValidatorCase, async: true
  use ExUnitProperties

  alias SBoM.CycloneDX
  alias SBoM.CycloneDX.XML.Encoder
  alias SBoM.DependencyGenerators
  alias SBoM.Fetcher
  alias SBoM.VulnerabilityGenerators

  doctest CycloneDX

  @tag :tmp_dir
  property "generates valid SBOM files in each format", %{tmp_dir: tmp_dir} do
    check all(
            raw_dependencies <- DependencyGenerators.dependency_map(),
            # TODO: Add "1.7" when CycloneDX CLI supports it
            schema <- member_of(["1.6", "1.5", "1.4", "1.3"]),
            format <- member_of([:json, :xml, :protobuf]),
            osv_vulnerabilities <- list_of(VulnerabilityGenerators.osv_vulnerability(), max_length: 3)
          ) do
      atom_dependencies =
        Map.new(raw_dependencies, fn {app_string, dep} ->
          {String.to_existing_atom(app_string), dep}
        end)

      dependencies = Fetcher.transform_all(atom_dependencies, enhance_metadata: false)

      bom = CycloneDX.bom_for_components(dependencies, version: schema)

      # Vulnerabilities are part of the schema since 1.4
      bom =
        if schema == "1.3" do
          bom
        else
          affected = dependencies |> Map.keys() |> Enum.take(2)
          osv_vulnerabilities = Enum.map(osv_vulnerabilities, &{&1, affected})

          Map.put(bom, :vulnerabilities, CycloneDX.convert_vulnerabilities(osv_vulnerabilities, dependencies, schema))
        end

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
    components = Fetcher.fetch(enhance_metadata: false)

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

      dependencies = Fetcher.transform_all(atom_dependencies, enhance_metadata: false)

      # Generate original BOM
      original_bom = CycloneDX.bom_for_components(dependencies, version: schema)

      # Encode to XML
      xml_string = CycloneDX.encode(original_bom, :xml)

      # Decode from XML
      decoded_bom = CycloneDX.decode(xml_string, :xml)

      # Compare canonicalized versions. Characters XML cannot represent come
      # back as U+FFFD, so the original is held to the same substitution.
      assert original_bom |> replace_xml_illegal_characters() |> cannonicalize_bom() ==
               cannonicalize_bom(decoded_bom)
    end
  end

  @spec replace_xml_illegal_characters(term()) :: term()
  defp replace_xml_illegal_characters(value)

  defp replace_xml_illegal_characters(%struct{} = value) do
    struct(struct, value |> Map.from_struct() |> replace_xml_illegal_characters())
  end

  defp replace_xml_illegal_characters(value) when is_map(value) do
    Map.new(value, fn {key, val} -> {key, replace_xml_illegal_characters(val)} end)
  end

  defp replace_xml_illegal_characters(value) when is_list(value), do: Enum.map(value, &replace_xml_illegal_characters/1)

  defp replace_xml_illegal_characters(value) when is_binary(value), do: Encoder.replace_illegal_characters(value)

  defp replace_xml_illegal_characters(value), do: value

  test "XML round-trip replaces characters XML cannot represent" do
    # \f and \e are printable to Elixir, so they arrive via package metadata,
    # but XML 1.0 cannot represent them even as a character reference.
    dependencies =
      Fetcher.transform_all(
        %{
          somedep: %{
            scm: Mix.SCM.Hex,
            version: "1.0.0",
            mix_dep: {:somedep, "~> 1.0", []},
            optional: false,
            runtime: true,
            targets: :*,
            only: :*,
            description: "before\fafter\eend"
          }
        },
        enhance_metadata: false
      )

    bom = CycloneDX.bom_for_components(dependencies, version: "1.6")
    xml = bom |> CycloneDX.encode(:xml) |> IO.iodata_to_binary()

    refute xml =~ "\f"
    refute xml =~ "\e"

    # The document is well-formed and the surrounding text survives; only the
    # unrepresentable characters become U+FFFD.
    decoded = CycloneDX.decode(xml, :xml)
    assert [%{description: "before\uFFFDafter\uFFFDend"}] = decoded.components
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

      dependencies = Fetcher.transform_all(atom_dependencies, enhance_metadata: false)

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

      dependencies = Fetcher.transform_all(atom_dependencies, enhance_metadata: false)

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

      dependencies = Fetcher.transform_all(atom_dependencies, enhance_metadata: false)

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

          dependencies = Fetcher.transform_all(atom_dependencies, enhance_metadata: false)

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
          components = Fetcher.fetch(enhance_metadata: false)
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
      components = Fetcher.fetch(enhance_metadata: false)
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

  describe "component group" do
    test "group field is populated in components" do
      components = Fetcher.fetch(enhance_metadata: false)
      bom = CycloneDX.bom_for_components(components)

      # Verify group is set for system components
      stdlib_component = Enum.find(bom.components, &(&1.name == "stdlib"))
      assert stdlib_component.group == "erlang.otp"
    end
  end

  describe "vulnerabilities" do
    @osv_vulnerability %{
      "id" => "GHSA-0000-0000-0000",
      "aliases" => ["CVE-2026-0000"],
      "summary" => "Example vulnerability",
      "details" => "Details of the example vulnerability.",
      "references" => [
        %{"type" => "ADVISORY", "url" => "https://example.com/advisory"},
        %{"type" => "WEB", "url" => "https://example.com"}
      ],
      "published" => "2026-01-01T00:00:00Z",
      "modified" => "2026-01-02T00:00:00.123456Z"
    }

    test "are converted from OSV.dev records" do
      components = Fetcher.fetch(enhance_metadata: false)

      assert [vulnerability] =
               CycloneDX.convert_vulnerabilities([{@osv_vulnerability, ["kernel", "jason"]}], components, "1.6")

      assert %{
               id: "GHSA-0000-0000-0000",
               source: %{name: "OSV", url: "https://osv.dev/vulnerability/GHSA-0000-0000-0000"},
               references: [%{id: "CVE-2026-0000", source: %{url: "https://osv.dev/vulnerability/CVE-2026-0000"}}],
               description: "Example vulnerability",
               detail: "Details of the example vulnerability.",
               advisories: [%{url: "https://example.com/advisory"}],
               affects: [_jason, _kernel]
             } = vulnerability

      assert vulnerability.published |> Google.Protobuf.to_datetime() |> DateTime.compare(~U[2026-01-01 00:00:00Z]) == :eq
      assert vulnerability.updated |> Google.Protobuf.to_datetime() |> DateTime.compare(~U[2026-01-02 00:00:00Z]) == :eq
    end

    test "keep only the id when OSV.dev returned no details" do
      components = Fetcher.fetch(enhance_metadata: false)

      assert [%{id: "GHSA-0000-0000-0000", description: nil, references: [], advisories: [], published: nil}] =
               CycloneDX.convert_vulnerabilities([{%{"id" => "GHSA-0000-0000-0000"}, ["jason"]}], components, "1.6")
    end

    @tag :tmp_dir
    test "generates valid SBOM files with vulnerabilities", %{tmp_dir: tmp_dir} do
      components = Fetcher.fetch(enhance_metadata: false)

      # TODO: Add "1.7" when CycloneDX CLI supports it
      for schema <- ["1.6", "1.5", "1.4"], format <- [:json, :xml, :protobuf] do
        vulnerabilities =
          CycloneDX.convert_vulnerabilities([{@osv_vulnerability, ["jason", "kernel"]}], components, schema)

        bom =
          components
          |> CycloneDX.bom_for_components(version: schema)
          |> Map.put(:vulnerabilities, vulnerabilities)

        assert [%{id: "GHSA-0000-0000-0000", affects: [_jason, _kernel]}] = bom.vulnerabilities

        file_path = Path.join(tmp_dir, "bom_vulnerabilities_#{schema}.#{format}")
        File.write!(file_path, CycloneDX.encode(bom, format))

        assert_valid_cyclonedx_bom(file_path, format)
      end
    end

    test "survive a JSON and XML round-trip" do
      components = Fetcher.fetch(enhance_metadata: false)

      for schema <- ["1.7", "1.6", "1.5", "1.4"], format <- [:json, :xml] do
        vulnerabilities =
          CycloneDX.convert_vulnerabilities([{@osv_vulnerability, ["jason", "kernel"]}], components, schema)

        bom =
          components
          |> CycloneDX.bom_for_components(version: schema)
          |> Map.put(:vulnerabilities, vulnerabilities)

        decoded_bom = bom |> CycloneDX.encode(format) |> IO.iodata_to_binary() |> CycloneDX.decode(format)

        assert decoded_bom.vulnerabilities == vulnerabilities
      end
    end

    test "are not looked up when disabled" do
      assert CycloneDX.bom(enhance_metadata: false, vulnerabilities: false).vulnerabilities == []
    end

    test "are not attached to schema 1.3" do
      components = Fetcher.fetch(enhance_metadata: false)

      bom = CycloneDX.bom_for_components(components, version: "1.3", vulnerabilities: true)

      refute Map.has_key?(bom, :vulnerabilities)
    end
  end
end
