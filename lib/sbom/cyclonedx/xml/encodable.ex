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
    SBoM.Cyclonedx.V17.ExternalReference,
    SBoM.Cyclonedx.V16.ExternalReference,
    SBoM.Cyclonedx.V15.ExternalReference,
    SBoM.Cyclonedx.V14.ExternalReference,
    SBoM.Cyclonedx.V13.ExternalReference
  ] do
  alias SBoM.CycloneDX.XML.Helpers

  @type external_reference_type() ::
          SBoM.Cyclonedx.V13.ExternalReferenceType.t()
          | SBoM.Cyclonedx.V14.ExternalReferenceType.t()
          | SBoM.Cyclonedx.V15.ExternalReferenceType.t()
          | SBoM.Cyclonedx.V16.ExternalReferenceType.t()
          | SBoM.Cyclonedx.V17.ExternalReferenceType.t()

  @impl SBoM.CycloneDX.XML.Encodable
  def to_xml_element(external_reference) do
    external_reference =
      Map.update!(external_reference, :type, &external_reference_type_to_string/1)

    # Use helpers to build structure
    attrs = Helpers.encode_fields_as_attrs([{:type, :type}], external_reference)

    content =
      Helpers.encode_fields_as_elements(
        [
          {:url, :url, :wrap},
          {:comment, :comment, :wrap},
          {:hashes, :hashes, :wrap},
          {:properties, :properties, :unwrap}
        ],
        external_reference
      )

    {:reference, attrs, content}
  end

  @spec external_reference_type_to_string(external_reference_type()) :: String.t()
  defp external_reference_type_to_string(:EXTERNAL_REFERENCE_TYPE_OTHER), do: "other"
  defp external_reference_type_to_string(:EXTERNAL_REFERENCE_TYPE_VCS), do: "vcs"

  defp external_reference_type_to_string(:EXTERNAL_REFERENCE_TYPE_ISSUE_TRACKER), do: "issue-tracker"

  defp external_reference_type_to_string(:EXTERNAL_REFERENCE_TYPE_WEBSITE), do: "website"
  defp external_reference_type_to_string(:EXTERNAL_REFERENCE_TYPE_ADVISORIES), do: "advisories"
  defp external_reference_type_to_string(:EXTERNAL_REFERENCE_TYPE_BOM), do: "bom"

  defp external_reference_type_to_string(:EXTERNAL_REFERENCE_TYPE_MAILING_LIST), do: "mailing-list"

  defp external_reference_type_to_string(:EXTERNAL_REFERENCE_TYPE_SOCIAL), do: "social"
  defp external_reference_type_to_string(:EXTERNAL_REFERENCE_TYPE_CHAT), do: "chat"

  defp external_reference_type_to_string(:EXTERNAL_REFERENCE_TYPE_DOCUMENTATION), do: "documentation"

  defp external_reference_type_to_string(:EXTERNAL_REFERENCE_TYPE_SUPPORT), do: "support"

  defp external_reference_type_to_string(:EXTERNAL_REFERENCE_TYPE_SOURCE_DISTRIBUTION), do: "source-distribution"

  defp external_reference_type_to_string(:EXTERNAL_REFERENCE_TYPE_DISTRIBUTION), do: "distribution"

  defp external_reference_type_to_string(:EXTERNAL_REFERENCE_TYPE_DISTRIBUTION_INTAKE), do: "distribution-intake"

  defp external_reference_type_to_string(:EXTERNAL_REFERENCE_TYPE_LICENSE), do: "license"
  defp external_reference_type_to_string(:EXTERNAL_REFERENCE_TYPE_BUILD_META), do: "build-meta"

  defp external_reference_type_to_string(:EXTERNAL_REFERENCE_TYPE_BUILD_SYSTEM), do: "build-system"

  defp external_reference_type_to_string(:EXTERNAL_REFERENCE_TYPE_RELEASE_NOTES), do: "release-notes"

  defp external_reference_type_to_string(:EXTERNAL_REFERENCE_TYPE_SECURITY_CONTACT), do: "security-contact"

  defp external_reference_type_to_string(:EXTERNAL_REFERENCE_TYPE_MODEL_CARD), do: "model-card"
  defp external_reference_type_to_string(:EXTERNAL_REFERENCE_TYPE_LOG), do: "log"

  defp external_reference_type_to_string(:EXTERNAL_REFERENCE_TYPE_CONFIGURATION), do: "configuration"

  defp external_reference_type_to_string(:EXTERNAL_REFERENCE_TYPE_EVIDENCE), do: "evidence"
  defp external_reference_type_to_string(:EXTERNAL_REFERENCE_TYPE_FORMULATION), do: "formulation"
  defp external_reference_type_to_string(:EXTERNAL_REFERENCE_TYPE_ATTESTATION), do: "attestation"

  defp external_reference_type_to_string(:EXTERNAL_REFERENCE_TYPE_THREAT_MODEL), do: "threat-model"

  defp external_reference_type_to_string(:EXTERNAL_REFERENCE_TYPE_ADVERSARY_MODEL), do: "adversary-model"

  defp external_reference_type_to_string(:EXTERNAL_REFERENCE_TYPE_RISK_ASSESSMENT), do: "risk-assessment"

  defp external_reference_type_to_string(:EXTERNAL_REFERENCE_TYPE_VULNERABILITY_ASSERTION), do: "vulnerability-assertion"

  defp external_reference_type_to_string(:EXTERNAL_REFERENCE_TYPE_EXPLOITABILITY_STATEMENT),
    do: "exploitability-statement"

  defp external_reference_type_to_string(:EXTERNAL_REFERENCE_TYPE_PENTEST_REPORT), do: "pentest-report"

  defp external_reference_type_to_string(:EXTERNAL_REFERENCE_TYPE_STATIC_ANALYSIS_REPORT), do: "static-analysis-report"

  defp external_reference_type_to_string(:EXTERNAL_REFERENCE_TYPE_DYNAMIC_ANALYSIS_REPORT), do: "dynamic-analysis-report"

  defp external_reference_type_to_string(:EXTERNAL_REFERENCE_TYPE_RUNTIME_ANALYSIS_REPORT), do: "runtime-analysis-report"

  defp external_reference_type_to_string(:EXTERNAL_REFERENCE_TYPE_COMPONENT_ANALYSIS_REPORT),
    do: "component-analysis-report"

  defp external_reference_type_to_string(:EXTERNAL_REFERENCE_TYPE_MATURITY_REPORT), do: "maturity-report"

  defp external_reference_type_to_string(:EXTERNAL_REFERENCE_TYPE_CERTIFICATION_REPORT), do: "certification-report"

  defp external_reference_type_to_string(:EXTERNAL_REFERENCE_TYPE_QUALITY_METRICS), do: "quality-metrics"

  defp external_reference_type_to_string(:EXTERNAL_REFERENCE_TYPE_CODIFIED_INFRASTRUCTURE), do: "codified-infrastructure"

  defp external_reference_type_to_string(:EXTERNAL_REFERENCE_TYPE_POAM), do: "poam"

  defp external_reference_type_to_string(:EXTERNAL_REFERENCE_TYPE_ELECTRONIC_SIGNATURE), do: "electronic-signature"

  defp external_reference_type_to_string(:EXTERNAL_REFERENCE_TYPE_DIGITAL_SIGNATURE), do: "digital-signature"

  defp external_reference_type_to_string(:EXTERNAL_REFERENCE_TYPE_RFC_9116), do: "rfc-9116"
  defp external_reference_type_to_string(:EXTERNAL_REFERENCE_TYPE_PATENT), do: "patent"

  defp external_reference_type_to_string(:EXTERNAL_REFERENCE_TYPE_PATENT_FAMILY), do: "patent-family"

  defp external_reference_type_to_string(:EXTERNAL_REFERENCE_TYPE_PATENT_ASSERTION), do: "patent-assertion"

  defp external_reference_type_to_string(:EXTERNAL_REFERENCE_TYPE_CITATION), do: "citation"
end

defimpl SBoM.CycloneDX.XML.Encodable,
  for: [
    SBoM.Cyclonedx.V17.Hash,
    SBoM.Cyclonedx.V16.Hash,
    SBoM.Cyclonedx.V15.Hash,
    SBoM.Cyclonedx.V14.Hash,
    SBoM.Cyclonedx.V13.Hash
  ] do
  @type hash_alg() ::
          SBoM.Cyclonedx.V13.HashAlg.t()
          | SBoM.Cyclonedx.V14.HashAlg.t()
          | SBoM.Cyclonedx.V15.HashAlg.t()
          | SBoM.Cyclonedx.V16.HashAlg.t()
          | SBoM.Cyclonedx.V17.HashAlg.t()

  @impl SBoM.CycloneDX.XML.Encodable
  def to_xml_element(hash) do
    alg_string = hash_alg_to_string(hash.alg)
    {:hash, [{:alg, alg_string}], [[hash.value]]}
  end

  @spec hash_alg_to_string(hash_alg()) :: String.t()
  defp hash_alg_to_string(:HASH_ALG_NULL), do: ""
  defp hash_alg_to_string(:HASH_ALG_MD_5), do: "MD5"
  defp hash_alg_to_string(:HASH_ALG_SHA_1), do: "SHA-1"
  defp hash_alg_to_string(:HASH_ALG_SHA_256), do: "SHA-256"
  defp hash_alg_to_string(:HASH_ALG_SHA_384), do: "SHA-384"
  defp hash_alg_to_string(:HASH_ALG_SHA_512), do: "SHA-512"
  defp hash_alg_to_string(:HASH_ALG_SHA_3_256), do: "SHA3-256"
  defp hash_alg_to_string(:HASH_ALG_SHA_3_384), do: "SHA3-384"
  defp hash_alg_to_string(:HASH_ALG_SHA_3_512), do: "SHA3-512"
  defp hash_alg_to_string(:HASH_ALG_BLAKE_2_B_256), do: "BLAKE2b-256"
  defp hash_alg_to_string(:HASH_ALG_BLAKE_2_B_384), do: "BLAKE2b-384"
  defp hash_alg_to_string(:HASH_ALG_BLAKE_2_B_512), do: "BLAKE2b-512"
  defp hash_alg_to_string(:HASH_ALG_BLAKE_3), do: "BLAKE3"
  defp hash_alg_to_string(:HASH_ALG_STREEBOG_256), do: "Streebog-256"
  defp hash_alg_to_string(:HASH_ALG_STREEBOG_512), do: "Streebog-512"
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
    attrs = Helpers.encode_fields_as_attrs([{:type, :type}, {:"bom-ref", :bom_ref}], component)

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
          {:licenses, :licenses, :unwrap},
          {:copyright, :copyright, :wrap},
          {:patentAssertions, :patent_assertions, :unwrap},
          {:cpe, :cpe, :wrap},
          {:purl, :purl, :wrap},
          {:externalReferences, :external_references, :wrap},
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
