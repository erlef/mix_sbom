# SPDX-License-Identifier: BSD-3-Clause
# SPDX-FileCopyrightText: 2025 Erlang Ecosystem Foundation

alias SBoM.CycloneDX
alias SBoM.CycloneDX.Common.EnumHelpers
alias SBoM.CycloneDX.XML.Decodable
alias SBoM.CycloneDX.XML.Decoder

require Protocol

schema_versions = ["1.7", "1.6", "1.5", "1.4", "1.3"]

defmodule SBoM.CycloneDX.XML.DecodableHelpers do
  @moduledoc false

  # Helper function for extracting and parsing wrapper value types
  @spec parse_wrapper_value(struct(), :xmerl.xmlElement(), function()) :: struct()
  def parse_wrapper_value(struct, xml_element, parser_fn) do
    case Decoder.extract_text(xml_element, "text()") do
      nil ->
        struct

      text ->
        case parser_fn.(text) do
          {:ok, value} -> %{struct | value: value}
          {:error, _error} -> struct
          {value, ""} -> %{struct | value: value}
          _parse_error -> struct
        end
    end
  end

  @spec parse_integer_positive(String.t()) :: {integer(), String.t()} | :error
  def parse_integer_positive(text) do
    case Integer.parse(text) do
      {value, ""} when value >= 0 -> {value, ""}
      _parse_error -> :error
    end
  end
end

defprotocol SBoM.CycloneDX.XML.Decodable do
  @moduledoc false

  # Protocol for converting XML elements to CycloneDX structs.
  #
  # This protocol provides custom control over XML decoding using XPath-based
  # extraction for clean, declarative field mapping from XML to structs.

  @fallback_to_any true

  @doc """
  Converts an XML element to a struct.

  Takes an empty struct for protocol dispatch and an XML element,
  returns a fully populated struct using XPath extraction.
  """
  @spec from_xml_element(struct(), :xmerl.xmlElement()) :: struct()
  def from_xml_element(empty_struct, xml_element)
end

defimpl Decodable, for: Any do
  @impl Decodable
  def from_xml_element(%module{} = struct, xml_element) when is_atom(module) do
    if function_exported?(module, :__message_props__, 0) do
      Decoder.decode_with_message_props(struct, xml_element)
    else
      throw({:bad_xml_element, xml_element, module})
    end
  end

  defmacro __deriving__(module, _struct, field_mappings) do
    escaped_mappings = Macro.escape(field_mappings)

    quote do
      defimpl Decodable, for: unquote(module) do
        @impl Decodable
        def from_xml_element(struct, xml_element) do
          xpath_mappings =
            for {field_name, xpath, type} <- unquote(escaped_mappings) do
              {field_name, type, xpath}
            end

          Decoder.decode_with_xpaths(struct, xml_element, xpath_mappings)
        end
      end
    end
  end
end

defimpl Decodable,
  for: [
    SBoM.CycloneDX.V17.ExternalReference,
    SBoM.CycloneDX.V16.ExternalReference,
    SBoM.CycloneDX.V15.ExternalReference,
    SBoM.CycloneDX.V14.ExternalReference,
    SBoM.CycloneDX.V13.ExternalReference
  ] do
  version = CycloneDX.bom_struct_version(@for)
  hash_module = CycloneDX.bom_struct_module(:Hash, version)

  @xpath_mappings [
    {:type, :string, "@type"},
    {:url, :string, "child::url/text()"},
    {:comment, :string, "child::comment/text()"},
    {:hashes, {:list, hash_module}, "child::hashes/child::hash"},
    {:properties, :string, "child::properties/text()"}
  ]

  @impl Decodable
  def from_xml_element(struct, xml_element) do
    decoded = Decoder.decode_with_xpaths(struct, xml_element, @xpath_mappings)

    # Transform string type back to enum
    if decoded.type do
      %{decoded | type: EnumHelpers.string_to_external_reference_type(decoded.type)}
    else
      decoded
    end
  end
end

defimpl Decodable,
  for: [
    SBoM.CycloneDX.V17.Hash,
    SBoM.CycloneDX.V16.Hash,
    SBoM.CycloneDX.V15.Hash,
    SBoM.CycloneDX.V14.Hash,
    SBoM.CycloneDX.V13.Hash
  ] do
  @xpath_mappings [
    {:alg, :string, "@alg"},
    {:value, :string, "text()"}
  ]

  @impl Decodable
  def from_xml_element(struct, xml_element) do
    decoded = Decoder.decode_with_xpaths(struct, xml_element, @xpath_mappings)

    # Transform string alg back to enum
    if decoded.alg do
      %{decoded | alg: EnumHelpers.string_to_hash_alg(decoded.alg)}
    else
      decoded
    end
  end
end

defimpl Decodable,
  for: [
    SBoM.CycloneDX.V17.Component,
    SBoM.CycloneDX.V16.Component,
    SBoM.CycloneDX.V15.Component,
    SBoM.CycloneDX.V14.Component,
    SBoM.CycloneDX.V13.Component
  ] do
  version = CycloneDX.bom_struct_version(@for)
  organizational_entity_module = CycloneDX.bom_struct_module(:OrganizationalEntity, version)
  hash_module = CycloneDX.bom_struct_module(:Hash, version)
  external_reference_module = CycloneDX.bom_struct_module(:ExternalReference, version)
  license_choice_module = CycloneDX.bom_struct_module(:LicenseChoice, version)
  property_module = CycloneDX.bom_struct_module(:Property, version)

  @xpath_mappings [
    {:type, :string, "@type"},
    {:bom_ref, :string, "@bom-ref"},
    {:supplier, {:element, organizational_entity_module}, "child::supplier"},
    {:manufacturer, {:element, organizational_entity_module}, "child::manufacturer"},
    {:author, :string, "child::author/text()"},
    {:publisher, :string, "child::publisher/text()"},
    {:group, :string, "child::group/text()"},
    {:name, :string, "child::name/text()"},
    {:version, :string, "child::version/text()"},
    {:description, :string, "child::description/text()"},
    {:scope, :string, "child::scope/text()"},
    {:hashes, {:list, hash_module}, "child::hashes/child::hash"},
    {:copyright, :string, "child::copyright/text()"},
    {:cpe, :string, "child::cpe/text()"},
    {:purl, :string, "child::purl/text()"},
    {:external_references, {:list, external_reference_module}, "child::externalReferences/child::reference"},
    {:components, {:list, @for}, "child::components/child::component"},
    {:licenses, {:list, license_choice_module}, "child::licenses/*"},
    {:properties, {:list, property_module}, "child::properties/child::property"}
  ]

  @impl Decodable
  def from_xml_element(struct, xml_element) do
    decoded = Decoder.decode_with_xpaths(struct, xml_element, @xpath_mappings)

    # Transform string enums back to atoms
    decoded =
      decoded
      |> transform_type_field()
      |> transform_scope_field()

    decoded
  end

  @spec transform_type_field(struct()) :: struct()
  defp transform_type_field(%{type: type} = component) when is_binary(type) do
    %{component | type: EnumHelpers.string_to_classification(type)}
  end

  defp transform_type_field(component), do: component

  @spec transform_scope_field(struct()) :: struct()
  defp transform_scope_field(%{scope: scope} = component) when is_binary(scope) do
    %{component | scope: EnumHelpers.string_to_scope(scope)}
  end

  defp transform_scope_field(component), do: component
end

defimpl Decodable,
  for: [
    SBoM.CycloneDX.V17.LicenseChoice,
    SBoM.CycloneDX.V16.LicenseChoice
  ] do
  import Decoder, only: [xml_element: 1]

  version = CycloneDX.bom_struct_version(@for)
  license_module = CycloneDX.bom_struct_module(:License, version)

  @license_xpath_mappings [
    {:bom_ref, :string, "@bom-ref"}
  ]

  @expression_xpath_mappings [
    {:bom_ref, :string, "@bom-ref"},
    {:acknowledgement, :string, "@acknowledgement"}
  ]

  @impl Decodable
  def from_xml_element(struct, xml_element(name: :license) = xml_element) do
    choice =
      unquote(license_module)
      |> struct()
      |> Decodable.from_xml_element(xml_element)

    struct = %{struct | choice: {:license, choice}}

    Decoder.decode_with_xpaths(struct, xml_element, @license_xpath_mappings)
  end

  def from_xml_element(struct, xml_element(name: :expression) = xml_element) do
    expression = Decoder.extract_text(xml_element, "text()")

    struct = %{struct | choice: {:expression, expression}}

    struct
    |> Decoder.decode_with_xpaths(xml_element, @expression_xpath_mappings)
    |> transform_acknowledgement_field()
  end

  @spec transform_acknowledgement_field(@for.t()) :: @for.t()
  defp transform_acknowledgement_field(%{acknowledgement: ack} = struct) when is_binary(ack) do
    %{struct | acknowledgement: EnumHelpers.string_to_license_acknowledgement(ack)}
  end

  defp transform_acknowledgement_field(struct), do: struct
end

defimpl Decodable,
  for: [
    SBoM.CycloneDX.V15.LicenseChoice,
    SBoM.CycloneDX.V14.LicenseChoice,
    SBoM.CycloneDX.V13.LicenseChoice
  ] do
  import Decoder, only: [xml_element: 1]

  version = CycloneDX.bom_struct_version(@for)
  license_module = CycloneDX.bom_struct_module(:License, version)

  @xpath_mappings [
    {:bom_ref, :string, "@bom-ref"}
  ]

  @impl Decodable
  def from_xml_element(struct, xml_element(name: :license) = xml_element) do
    choice =
      unquote(license_module)
      |> struct()
      |> Decodable.from_xml_element(xml_element)

    struct = %{struct | choice: {:license, choice}}

    Decoder.decode_with_xpaths(struct, xml_element, @xpath_mappings)
  end

  def from_xml_element(struct, xml_element(name: :expression) = xml_element) do
    expression = Decoder.extract_text(xml_element, "text()")

    %{struct | choice: {:expression, expression}}
  end
end

defimpl Decodable, for: Google.Protobuf.Timestamp do
  @impl Decodable
  def from_xml_element(struct, xml_element) do
    case Decoder.extract_text(xml_element, "text()") do
      nil ->
        struct

      iso_string ->
        case DateTime.from_iso8601(iso_string) do
          {:ok, datetime, _offset} -> Google.Protobuf.from_datetime(datetime)
          {:error, _reason} -> struct
        end
    end
  end
end

defimpl Decodable, for: Google.Protobuf.StringValue do
  @impl Decodable
  def from_xml_element(struct, xml_element) do
    case Decoder.extract_text(xml_element, "text()") do
      nil -> struct
      value -> %{struct | value: value}
    end
  end
end

defimpl Decodable, for: Google.Protobuf.BoolValue do
  @impl Decodable
  def from_xml_element(struct, xml_element) do
    case Decoder.extract_text(xml_element, "text()") do
      nil -> struct
      "true" -> %{struct | value: true}
      "false" -> %{struct | value: false}
      _other_value -> struct
    end
  end
end

defimpl Decodable, for: Google.Protobuf.Int32Value do
  @impl Decodable
  def from_xml_element(struct, xml_element) do
    SBoM.CycloneDX.XML.DecodableHelpers.parse_wrapper_value(struct, xml_element, &Integer.parse/1)
  end
end

defimpl Decodable, for: Google.Protobuf.Int64Value do
  @impl Decodable
  def from_xml_element(struct, xml_element) do
    SBoM.CycloneDX.XML.DecodableHelpers.parse_wrapper_value(struct, xml_element, &Integer.parse/1)
  end
end

defimpl Decodable, for: Google.Protobuf.UInt32Value do
  @impl Decodable
  def from_xml_element(struct, xml_element) do
    SBoM.CycloneDX.XML.DecodableHelpers.parse_wrapper_value(
      struct,
      xml_element,
      &SBoM.CycloneDX.XML.DecodableHelpers.parse_integer_positive/1
    )
  end
end

defimpl Decodable, for: Google.Protobuf.UInt64Value do
  @impl Decodable
  def from_xml_element(struct, xml_element) do
    SBoM.CycloneDX.XML.DecodableHelpers.parse_wrapper_value(
      struct,
      xml_element,
      &SBoM.CycloneDX.XML.DecodableHelpers.parse_integer_positive/1
    )
  end
end

defimpl Decodable, for: Google.Protobuf.FloatValue do
  @impl Decodable
  def from_xml_element(struct, xml_element) do
    SBoM.CycloneDX.XML.DecodableHelpers.parse_wrapper_value(struct, xml_element, &Float.parse/1)
  end
end

defimpl Decodable, for: Google.Protobuf.DoubleValue do
  @impl Decodable
  def from_xml_element(struct, xml_element) do
    SBoM.CycloneDX.XML.DecodableHelpers.parse_wrapper_value(struct, xml_element, &Float.parse/1)
  end
end

defimpl Decodable, for: Google.Protobuf.BytesValue do
  @impl Decodable
  def from_xml_element(struct, xml_element) do
    SBoM.CycloneDX.XML.DecodableHelpers.parse_wrapper_value(struct, xml_element, &Base.decode64/1)
  end
end

defimpl Decodable, for: Google.Protobuf.FieldMask do
  @impl Decodable
  def from_xml_element(struct, xml_element) do
    case Decoder.extract_text(xml_element, "text()") do
      nil ->
        struct

      paths_string ->
        paths =
          paths_string
          |> String.split(",")
          |> Enum.map(&String.trim/1)
          |> Enum.map(&convert_field_mask_to_underscore/1)

        %{struct | paths: paths}
    end
  end

  @spec convert_field_mask_to_underscore(String.t()) :: String.t()
  defp convert_field_mask_to_underscore(mask) do
    if mask =~ ~r/^[a-zA-Z0-9\.]+$/ do
      mask
      |> String.split(".")
      |> Enum.map_join(".", &Macro.underscore/1)
    else
      throw({:bad_field_mask, mask})
    end
  end
end

for version <- schema_versions do
  dependency_module = CycloneDX.bom_struct_module(:Dependency, version)

  Protocol.derive(Decodable, dependency_module, [
    {:ref, "@ref", :string},
    {:dependencies, "child::dependency", {:list, dependency_module}}
  ])
end

for version <- schema_versions do
  bom_module = CycloneDX.bom_struct_module(:Bom, version)
  metadata_module = CycloneDX.bom_struct_module(:Metadata, version)
  component_module = CycloneDX.bom_struct_module(:Component, version)
  external_reference_module = CycloneDX.bom_struct_module(:ExternalReference, version)
  dependency_module = CycloneDX.bom_struct_module(:Dependency, version)

  Protocol.derive(Decodable, bom_module, [
    {:version, "@version", :int32},
    {:serial_number, "@serialNumber", :string},
    {:metadata, "child::metadata", {:element, metadata_module}},
    {:components, "child::components/child::component", {:list, component_module}},
    {:external_references, "child::external-references/child::reference", {:list, external_reference_module}},
    {:dependencies, "child::dependencies/child::dependency", {:list, dependency_module}}
  ])
end

for version <- schema_versions do
  metadata_module = CycloneDX.bom_struct_module(:Metadata, version)
  component_module = CycloneDX.bom_struct_module(:Component, version)
  organizational_entity_module = CycloneDX.bom_struct_module(:OrganizationalEntity, version)
  license_choice_module = CycloneDX.bom_struct_module(:LicenseChoice, version)
  tool_module = CycloneDX.bom_struct_module(:Tool, version)

  fields = [
    {:timestamp, "child::timestamp", {:element, Google.Protobuf.Timestamp}},
    {:component, "child::component", {:element, component_module}},
    {:manufacturer, "child::manufacturer", {:element, organizational_entity_module}},
    {:supplier, "child::supplier", {:element, organizational_entity_module}},
    {:licenses, "child::licenses/*", {:list, license_choice_module}}
  ]

  # Version-specific fields
  fields =
    if version in ["1.6", "1.7"] do
      [{:manufacture, "child::manufacture", {:element, organizational_entity_module}} | fields]
    else
      fields
    end

  fields =
    if version in ["1.3", "1.4"] do
      [{:tools, "child::tools/child::tool", {:list, tool_module}} | fields]
    else
      [{:tools, "child::tools", {:element, tool_module}} | fields]
    end

  Protocol.derive(Decodable, metadata_module, fields)
end

for version <- schema_versions do
  tool_module = CycloneDX.bom_struct_module(:Tool, version)
  component_module = CycloneDX.bom_struct_module(:Component, version)

  Protocol.derive(Decodable, tool_module, [
    {:vendor, "child::vendor/text()", :string},
    {:name, "child::name/text()", :string},
    {:version, "child::version/text()", :string},
    {:components, "child::components/child::component", {:list, component_module}}
  ])
end

for version <- schema_versions do
  organizational_entity_module = CycloneDX.bom_struct_module(:OrganizationalEntity, version)

  Protocol.derive(Decodable, organizational_entity_module, [
    {:name, "child::name/text()", :string},
    {:url, "child::url/text()", :string}
  ])
end

defimpl Decodable,
  for: [SBoM.CycloneDX.V17.License, SBoM.CycloneDX.V16.License] do
  @xpath_mappings [
    {:bom_ref, :string, "@bom-ref"},
    {:acknowledgement, :string, "@acknowledgement"},
    {{:license, :id}, :string, "child::id/text()"},
    {{:license, :name}, :string, "child::name/text()"}
  ]

  @impl Decodable
  def from_xml_element(struct, xml_element) do
    struct
    |> Decoder.decode_with_xpaths(xml_element, @xpath_mappings)
    |> transform_acknowledgement_field()
  end

  @spec transform_acknowledgement_field(@for.t()) :: @for.t()
  defp transform_acknowledgement_field(%{acknowledgement: ack} = struct) when is_binary(ack) do
    %{struct | acknowledgement: EnumHelpers.string_to_license_acknowledgement(ack)}
  end

  defp transform_acknowledgement_field(struct), do: struct
end

for version <- ["1.5", "1.4", "1.3"] do
  license_module = CycloneDX.bom_struct_module(:License, version)

  Protocol.derive(Decodable, license_module, [
    {:bom_ref, "@bom-ref", :string},
    {{:license, :id}, "child::id/text()", :string},
    {{:license, :name}, "child::name/text()", :string}
  ])
end
