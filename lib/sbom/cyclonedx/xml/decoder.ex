# SPDX-License-Identifier: BSD-3-Clause
# SPDX-FileCopyrightText: 2025 Erlang Ecosystem Foundation

defmodule SBoM.CycloneDX.XML.Decoder do
  @moduledoc false
  @behaviour SBoM.CycloneDX.Common.FieldAccess

  # XML decoding helpers for CycloneDX.
  import Record, only: [defrecord: 3, extract: 2]

  alias SBoM.CycloneDX.Common.Decoder
  alias SBoM.CycloneDX.Common.FieldAccess
  alias SBoM.CycloneDX.XML.Decodable

  defrecord :xml_element, :xmlElement, extract(:xmlElement, from_lib: "xmerl/include/xmerl.hrl")

  defrecord :xml_attribute,
            :xmlAttribute,
            extract(:xmlAttribute, from_lib: "xmerl/include/xmerl.hrl")

  defrecord :xml_text, :xmlText, extract(:xmlText, from_lib: "xmerl/include/xmerl.hrl")

  @spec from_xml_element(term(), module()) :: struct()
  def from_xml_element(xml_element, module) when is_atom(module) do
    module
    |> struct()
    |> Decodable.from_xml_element(xml_element)
  end

  @spec decode_struct(struct(), map()) :: struct()
  def decode_struct(struct, data) when is_map(data) do
    Decoder.decode_struct(struct, data, __MODULE__)
  end

  @impl FieldAccess
  def fetch_field_value(%Protobuf.FieldProps{name_atom: name_atom}, data) do
    case Map.get(data, name_atom) do
      nil -> :error
      value -> {:ok, value}
    end
  end

  @impl FieldAccess
  def decode_bool_scalar(_name, value) do
    cond do
      is_boolean(value) -> value
      value == "true" -> true
      value == "false" -> false
    end
  end

  @impl FieldAccess
  def decode_embedded(xml_element, module) do
    from_xml_element(xml_element, module)
  end

  @spec decode_scalar(atom(), atom(), term()) :: term()
  def decode_scalar(type, name, value) do
    Decoder.decode_scalar(type, name, value, __MODULE__)
  end

  defdelegate transform_module(message, module), to: Decoder
  defdelegate convert_field_mask_to_underscore(mask), to: Decoder

  # === XML DECODING HELPERS ===

  @type xpath_mapping() ::
          {atom(), scalar_type(), String.t()}
          | {atom(), {:element, module()}, String.t()}
          | {atom(), {:list, module()}, String.t()}
          | {{atom(), atom()}, scalar_type(), String.t()}
          | {{atom(), atom()}, {:element, module()}, String.t()}
          | {{atom(), atom()}, {:list, module()}, String.t()}

  @type scalar_type() ::
          :string
          | :bool
          | :bytes
          | :float
          | :double
          | :int32
          | :int64
          | :sint32
          | :sint64
          | :sfixed32
          | :sfixed64
          | :fixed32
          | :fixed64
          | :uint32
          | :uint64

  @doc """
  Decode XML element using XPath-based field mappings.
  """
  @spec decode_with_xpaths(struct(), :xmerl.xmlElement(), [xpath_mapping()]) :: struct()
  def decode_with_xpaths(struct, xml_element, xpath_mappings) do
    fields =
      for mapping <- xpath_mappings,
          {key, value} = decode_xpath_mapping(mapping, xml_element),
          value != nil do
        {key, value}
      end

    struct(struct, fields)
  end

  @spec decode_xpath_mapping(xpath_mapping(), :xmerl.xmlElement()) :: {atom(), term()}
  defp decode_xpath_mapping({field_spec, type, xpath}, xml_element) do
    raw_value = extract_typed_value(type, xpath, xml_element, field_spec)
    wrap_field_result(field_spec, raw_value)
  end

  @spec extract_typed_value(term(), String.t(), :xmerl.xmlElement(), term()) :: term()
  defp extract_typed_value({:element, module}, xpath, xml_element, _field_spec) do
    extract_element(xml_element, xpath, module)
  end

  defp extract_typed_value({:list, module}, xpath, xml_element, _field_spec) do
    extract_element_list(xml_element, xpath, module)
  end

  defp extract_typed_value(scalar_type, xpath, xml_element, field_spec) when is_atom(scalar_type) do
    extract_and_decode_scalar(scalar_type, xpath, xml_element, field_spec)
  end

  @spec extract_and_decode_scalar(atom(), String.t(), :xmerl.xmlElement(), term()) :: term()
  defp extract_and_decode_scalar(scalar_type, xpath, xml_element, field_spec) do
    extracted = extract_value_by_xpath(xpath, xml_element)

    if extracted do
      field_name = get_field_name(field_spec)
      Decoder.decode_scalar(scalar_type, field_name, extracted, __MODULE__)
    end
  end

  @spec extract_value_by_xpath(String.t(), :xmerl.xmlElement()) :: String.t() | nil
  defp extract_value_by_xpath(xpath, xml_element) do
    if String.starts_with?(xpath, "@") do
      extract_attribute(xml_element, xpath)
    else
      extract_text(xml_element, xpath)
    end
  end

  @spec get_field_name(term()) :: atom()
  defp get_field_name({field_name, _variant}), do: field_name
  defp get_field_name(field_name), do: field_name

  @spec wrap_field_result(term(), term()) :: {atom(), term()}
  defp wrap_field_result({field_name, variant_type}, raw_value) do
    value = if raw_value, do: {variant_type, raw_value}
    {field_name, value}
  end

  defp wrap_field_result(field_name, raw_value) do
    {field_name, raw_value}
  end

  @doc """
  Decode XML element using protobuf message props for automatic field mapping.
  """
  @spec decode_with_message_props(struct(), :xmerl.xmlElement()) :: struct()
  def decode_with_message_props(%module{} = struct, xml_element) do
    message_props = module.__message_props__()

    # Extract fields from XML using XPath
    extracted_fields = extract_fields_from_xml(xml_element, message_props)

    # Use the XML decoder to process the extracted fields with proper type conversion
    decode_struct(struct, extracted_fields)
  end

  @spec extract_fields_from_xml(:xmerl.xmlElement(), map()) :: map()
  defp extract_fields_from_xml(xml_element, %{field_props: field_props}) do
    field_props
    |> Enum.map(fn {_field_num, %Protobuf.FieldProps{} = prop} ->
      xml_name = xml_element_name(prop)

      raw_value =
        cond do
          prop.repeated? and prop.embedded? ->
            extract_nested_elements(xml_element, xml_name)

          prop.embedded? ->
            extract_nested_element(xml_element, xml_name)

          prop.repeated? ->
            extract_repeated_text_values(xml_element, xml_name)

          true ->
            extract_text(xml_element, "child::#{xml_name}/text()")
        end

      {prop.name_atom, raw_value}
    end)
    |> Enum.reject(fn {_key, value} -> is_nil(value) end)
    |> Map.new()
  end

  # Extract multiple nested XML elements as a list of XML elements for processing
  @spec extract_nested_elements(:xmerl.xmlElement(), String.t()) :: [:xmerl.xmlElement()] | nil
  defp extract_nested_elements(xml_element, xml_name) do
    "child::#{xml_name}"
    |> to_charlist()
    |> :xmerl_xpath.string(xml_element)
    |> case do
      [_first | _rest] = elements -> elements
      [] -> nil
      _other -> nil
    end
  end

  # Extract single nested XML element
  @spec extract_nested_element(:xmerl.xmlElement(), String.t()) :: :xmerl.xmlElement() | nil
  defp extract_nested_element(xml_element, xml_name) do
    "child::#{xml_name}"
    |> to_charlist()
    |> :xmerl_xpath.string(xml_element)
    |> case do
      [element] -> element
      [] -> nil
      _other -> nil
    end
  end

  # Extract repeated text values as a list of strings
  @spec extract_repeated_text_values(:xmerl.xmlElement(), String.t()) :: [String.t()] | nil
  defp extract_repeated_text_values(xml_element, xml_name) do
    "child::#{xml_name}/text()"
    |> to_charlist()
    |> :xmerl_xpath.string(xml_element)
    |> case do
      [_first | _rest] = text_nodes ->
        text_nodes
        |> Enum.map(fn
          xml_text(value: value) when is_list(value) -> to_string(value)
          value when is_binary(value) -> to_string(value)
          value when is_list(value) -> to_string(value)
          _other -> nil
        end)
        |> Enum.reject(&is_nil/1)

      [] ->
        nil

      _other ->
        nil
    end
  end

  @doc """
  Extract attribute value using XPath.
  """
  @spec extract_attribute(:xmerl.xmlElement(), String.t()) :: String.t() | nil
  def extract_attribute(xml_element, xpath) do
    xpath
    |> to_charlist()
    |> :xmerl_xpath.string(xml_element)
    |> case do
      [xml_attribute(value: value)] -> to_string(value)
      [] -> nil
    end
  end

  @doc """
  Extract text content using XPath.
  """
  @spec extract_text(:xmerl.xmlElement(), String.t()) :: String.t() | nil
  def extract_text(xml_element, xpath) do
    xpath
    |> to_charlist()
    |> :xmerl_xpath.string(xml_element)
    |> case do
      [xml_text(value: value)] when is_list(value) -> to_string(value)
      [] -> nil
    end
  end

  @doc """
  Extract single nested element using XPath and convert to struct.
  """
  @spec extract_element(:xmerl.xmlElement(), String.t(), module()) :: struct() | nil
  def extract_element(xml_element, xpath, module) do
    xpath
    |> to_charlist()
    |> :xmerl_xpath.string(xml_element)
    |> case do
      [child_element] ->
        module
        |> struct()
        |> Decodable.from_xml_element(child_element)

      [] ->
        nil
    end
  end

  @doc """
  Extract list of elements using XPath and convert to struct list.
  """
  @spec extract_element_list(:xmerl.xmlElement(), String.t(), module()) :: [struct()]
  def extract_element_list(xml_element, xpath, module) do
    xpath
    |> to_charlist()
    |> :xmerl_xpath.string(xml_element)
    |> case do
      elements when is_list(elements) ->
        Enum.map(elements, fn element ->
          module
          |> struct()
          |> Decodable.from_xml_element(element)
        end)
    end
  end

  @doc """
  Extract enum value using XPath and transformation function.
  """
  @spec extract_enum(:xmerl.xmlElement(), String.t(), function()) :: atom() | nil
  def extract_enum(xml_element, xpath, transform_fn) do
    case extract_attribute(xml_element, xpath) || extract_text(xml_element, xpath) do
      nil -> nil
      value -> transform_fn.(value)
    end
  end

  # Convert protobuf field name to XML element name
  @spec xml_element_name(Protobuf.FieldProps.t()) :: String.t()
  defp xml_element_name(%Protobuf.FieldProps{json_name: json_name}) do
    # Convert camelCase to kebab-case for XML elements
    json_name
    |> String.replace(~r/([a-z])([A-Z])/, "\\1-\\2")
    |> String.downcase()
  end
end
