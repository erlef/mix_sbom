# SPDX-License-Identifier: BSD-3-Clause
# SPDX-FileCopyrightText: 2025 Erlang Ecosystem Foundation

defmodule SBoM.CycloneDX.XML.Encoder do
  @moduledoc false

  alias SBoM.CycloneDX.XML.Encodable

  @type action() :: :wrap | :unwrap | :keep
  @type element_field_mapping() :: {atom(), atom() | {atom(), atom()}, action()}
  @type attr_field_mapping() :: {atom(), atom() | {:static, term()}}

  @doc """
  Converts struct fields to XML child elements using explicit 3-tuple syntax.
  Format: {:"xml-element-name", :struct_field_name, :wrap|:unwrap|:keep}

  For oneof fields, use: {:"xml-element-name", {:oneof_field_name, :choice_name}, :wrap|:unwrap|:keep}
  Only includes the element if the oneof field matches the specified choice.
  """
  @spec encode_fields_as_elements([element_field_mapping()], struct()) :: [
          :xmerl.simple_element()
        ]
  def encode_fields_as_elements(field_mappings, struct) when is_list(field_mappings) do
    for_result =
      for {xml_name, struct_field, action} <- field_mappings do
        case struct_field do
          {oneof_field, choice_name} ->
            # Handle oneof pattern: {oneof_field, choice_name}
            case Map.get(struct, oneof_field) do
              {^choice_name, value} ->
                # Choice matches, proceed with action on the value
                apply_action(xml_name, value, action)

              _other_choice ->
                # Choice doesn't match, skip this element
                nil
            end

          struct_field when is_atom(struct_field) ->
            # Handle regular field
            value = Map.get(struct, struct_field)
            apply_action(xml_name, value, action)
        end
      end

    filter_present_fields(for_result)
  end

  @spec apply_action(atom(), term(), action()) :: :xmerl.simple_element() | nil
  defp apply_action(_xml_name, nil, _action), do: nil
  defp apply_action(_xml_name, "", _action), do: nil
  defp apply_action(_xml_name, [], _action), do: nil

  defp apply_action(_xml_name, value, :keep) do
    Encodable.to_xml_element(value)
  end

  defp apply_action(xml_name, value, :wrap) do
    # Simple value → wrap in XML element
    content = Encodable.to_xml_element(value)
    {xml_name, [], content}
  end

  defp apply_action(xml_name, value, :unwrap) do
    {attrs, content} =
      case Encodable.to_xml_element(value) do
        list when is_list(list) ->
          {[], Enum.flat_map(list, fn {_elem, _attrs, content} -> content end)}

        {_elem, attrs, content} ->
          {attrs, content}
      end

    {xml_name, attrs, content}
  end

  @doc """
  Converts struct fields to XML attributes.
  Supports field mappings ({:xml_name, :struct_field}) and static values ({:xml_name, {:static, value}}).
  """
  @spec encode_fields_as_attrs([attr_field_mapping()], struct()) :: [:xmerl.simple_attribute()]
  def encode_fields_as_attrs(field_mappings, struct) when is_list(field_mappings) do
    for_result =
      for field_spec <- field_mappings do
        case field_spec do
          {xml_name, {:static, static_value}} ->
            encode_field_as_attr(xml_name, static_value)

          {xml_name, struct_field} ->
            value = Map.get(struct, struct_field)
            encode_field_as_attr(xml_name, value)
        end
      end

    filter_present_fields(for_result)
  end

  @spec encode_field_as_attr(atom(), term()) :: :xmerl.simple_attribute() | nil
  defp encode_field_as_attr(_field, nil), do: nil
  defp encode_field_as_attr(_field, ""), do: nil

  defp encode_field_as_attr(field, value) do
    {field, to_string(value)}
  end

  @spec filter_present_fields([entry]) :: [entry]
        when entry: :xmerl.simple_element() | :xmerl.simple_attribute()
  defp filter_present_fields(fields) when is_list(fields) do
    fields
    |> List.flatten()
    |> Enum.reject(&is_nil/1)
  end
end
