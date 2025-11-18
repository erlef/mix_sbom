defmodule SBoM.CycloneDX.XML.Helpers do
  @moduledoc """
  Generic XML structure building helpers for CycloneDX encoding.
  """

  alias SBoM.CycloneDX.XML.Encodable

  @doc """
  Converts struct fields to XML child elements using explicit 3-tuple syntax.
  Format: {:"xml-element-name", :struct_field_name, :wrap|:unwrap|:keep}

  For oneof fields, use: {:"xml-element-name", {:oneof_field_name, :choice_name}, :wrap|:unwrap|:keep}
  Only includes the element if the oneof field matches the specified choice.
  """
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

              _ ->
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
    {_elem, attrs, content} = Encodable.to_xml_element(value)
    {xml_name, attrs, content}
  end

  @doc """
  Converts struct fields to XML attributes.
  Supports field mappings ({:xml_name, :struct_field}) and static values ({:xml_name, {:static, value}}).
  """
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

  defp encode_field_as_attr(_field, nil), do: nil
  defp encode_field_as_attr(_field, ""), do: nil

  defp encode_field_as_attr(field, value) do
    {field, to_string(value)}
  end

  defp filter_present_fields(fields) when is_list(fields) do
    fields
    |> List.flatten()
    |> Enum.reject(&is_nil/1)
  end
end
