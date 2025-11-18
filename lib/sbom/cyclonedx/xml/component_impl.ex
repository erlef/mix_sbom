defmodule SBoM.CycloneDX.XML.ComponentImpl do
  @moduledoc """
  Manual XML protocol implementations for Component structs that need custom transformations.
  """

  alias SBoM.CycloneDX.XML.Helpers

  # Component implementations with classification conversion
  defimpl SBoM.CycloneDX.XML.Encodable,
    for: [
      SBoM.Cyclonedx.V17.Component,
      SBoM.Cyclonedx.V16.Component,
      SBoM.Cyclonedx.V15.Component,
      SBoM.Cyclonedx.V14.Component,
      SBoM.Cyclonedx.V13.Component
    ] do
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

    defp scope_to_string(:SCOPE_UNSPECIFIED), do: nil
    defp scope_to_string(:SCOPE_REQUIRED), do: "required"
    defp scope_to_string(:SCOPE_OPTIONAL), do: "optional"
    defp scope_to_string(:SCOPE_EXCLUDED), do: "excluded"
    defp scope_to_string(nil), do: nil
  end
end
