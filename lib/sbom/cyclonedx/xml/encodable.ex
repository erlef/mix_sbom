# SPDX-License-Identifier: BSD-3-Clause
# SPDX-FileCopyrightText: 2025 Erlang Ecosystem Foundation

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
          # Safe: String.to_atom is called at compile time with well-known module names during macro expansion
          # credo:disable-for-next-line Credo.Check.Warning.UnsafeToAtom
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

defimpl SBoM.CycloneDX.XML.Encodable,
  for: [
    SBoM.Cyclonedx.V17.Component,
    SBoM.Cyclonedx.V16.Component,
    SBoM.Cyclonedx.V15.Component,
    SBoM.Cyclonedx.V14.Component,
    SBoM.Cyclonedx.V13.Component
  ] do
  alias SBoM.CycloneDX.XML.Helpers

  @type classification() ::
          SBoM.Cyclonedx.V13.Classification.t()
          | SBoM.Cyclonedx.V14.Classification.t()
          | SBoM.Cyclonedx.V15.Classification.t()
          | SBoM.Cyclonedx.V16.Classification.t()
          | SBoM.Cyclonedx.V17.Classification.t()
  @type scope() ::
          SBoM.Cyclonedx.V13.Scope.t()
          | SBoM.Cyclonedx.V14.Scope.t()
          | SBoM.Cyclonedx.V15.Scope.t()
          | SBoM.Cyclonedx.V16.Scope.t()
          | SBoM.Cyclonedx.V17.Scope.t()

  @impl SBoM.CycloneDX.XML.Encodable
  def to_xml_element(component) do
    component =
      component
      |> Map.update!(:type, &classification_to_string/1)
      |> Map.update(:scope, nil, &scope_to_string/1)

    # Use helpers to build structure
    attrs = Helpers.encode_fields_as_attrs([{:type, :type}], component)

    content =
      Helpers.encode_fields_as_elements(
        [
          {:supplier, :supplier, :unwrap},
          {:manufacturer, :manufacturer, :unwrap},
          {:authors, :authors, :unwrap},
          {:author, :author, :wrap},
          {:publisher, :publisher, :wrap},
          {:group, :group, :wrap},
          {:name, :name, :wrap},
          {:version, :version, :wrap},
          {:versionRange, :version_range, :wrap},
          {:description, :description, :wrap},
          {:scope, :scope, :wrap},
          {:hashes, :hashes, :unwrap},
          {:licenses, :licenses, :keep},
          {:copyright, :copyright, :wrap},
          {:patentAssertions, :patent_assertions, :unwrap},
          {:cpe, :cpe, :wrap},
          {:purl, :purl, :wrap},
          {:externalReferences, :external_references, :unwrap},
          {:properties, :properties, :unwrap},
          {:evidence, :evidence, :unwrap},
          {:releaseNotes, :release_notes, :unwrap},
          {:modelCard, :model_card, :unwrap},
          {:data, :data, :unwrap},
          {:cryptoProperties, :crypto_properties, :unwrap},
          {:components, :components, :unwrap}
        ],
        component
      )

    {:component, attrs, content}
  end

  @spec classification_to_string(classification()) :: String.t()
  defp classification_to_string(:CLASSIFICATION_NULL), do: ""
  defp classification_to_string(:CLASSIFICATION_APPLICATION), do: "application"
  defp classification_to_string(:CLASSIFICATION_FRAMEWORK), do: "framework"
  defp classification_to_string(:CLASSIFICATION_LIBRARY), do: "library"
  defp classification_to_string(:CLASSIFICATION_OPERATING_SYSTEM), do: "operating-system"
  defp classification_to_string(:CLASSIFICATION_DEVICE), do: "device"
  defp classification_to_string(:CLASSIFICATION_FILE), do: "file"
  defp classification_to_string(:CLASSIFICATION_CONTAINER), do: "container"
  defp classification_to_string(:CLASSIFICATION_FIRMWARE), do: "firmware"
  defp classification_to_string(:CLASSIFICATION_DEVICE_DRIVER), do: "device-driver"
  defp classification_to_string(:CLASSIFICATION_PLATFORM), do: "platform"

  defp classification_to_string(:CLASSIFICATION_MACHINE_LEARNING_MODEL), do: "machine-learning-model"

  defp classification_to_string(:CLASSIFICATION_DATA), do: "data"
  defp classification_to_string(:CLASSIFICATION_CRYPTOGRAPHIC_ASSET), do: "cryptographic-asset"

  @spec scope_to_string(scope() | nil) :: String.t() | nil
  defp scope_to_string(:SCOPE_UNSPECIFIED), do: nil
  defp scope_to_string(:SCOPE_REQUIRED), do: "required"
  defp scope_to_string(:SCOPE_OPTIONAL), do: "optional"
  defp scope_to_string(:SCOPE_EXCLUDED), do: "excluded"
  defp scope_to_string(nil), do: nil
end
