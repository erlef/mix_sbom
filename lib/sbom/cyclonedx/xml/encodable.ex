defprotocol SBoM.CycloneDX.XML.Encodable do
  @doc """
  Converts a CycloneDX struct to an XML element tuple suitable for :xmerl.

  Returns a tuple in the format {element_name, attributes, content}.
  """
  def to_xml_element(struct)
end

defimpl SBoM.CycloneDX.XML.Encodable, for: Any do
  def to_xml_element(_value) do
    raise "No XML Encodable implementation for #{inspect(__MODULE__)}"
  end

  defmacro __deriving__(module, _struct, options) do
    attributes = options |> Keyword.get(:attributes, []) |> Macro.escape()
    elements = options |> Keyword.get(:elements, []) |> Macro.escape()

    element_name =
      case Keyword.get(options, :element_name, nil) do
        nil ->
          module |> Module.split() |> List.last() |> Macro.underscore() |> String.to_atom()

        name ->
          name
      end

    quote do
      defimpl SBoM.CycloneDX.XML.Encodable, for: unquote(module) do
        alias SBoM.CycloneDX.XML.Helpers

        def to_xml_element(struct) do
          attrs = Helpers.encode_fields_as_attrs(unquote(attributes), struct)
          element_content = Helpers.encode_fields_as_elements(unquote(elements), struct)

          {unquote(element_name), attrs, element_content}
        end
      end
    end
  end
end
