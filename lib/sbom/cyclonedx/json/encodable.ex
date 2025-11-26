# SPDX-License-Identifier: BSD-3-Clause
# SPDX-FileCopyrightText: 2025 Erlang Ecosystem Foundation

defprotocol SBoM.CycloneDX.JSON.Encodable do
  @moduledoc """
  Protocol for converting CycloneDX structs to JSON-encodable data structures.

  This protocol provides custom control over JSON encoding while maintaining
  compatibility with Protobuf's built-in JSON encoding for generated structs.
  """

  @fallback_to_any true

  @doc """
  Converts a struct to a JSON-encodable data structure.

  Returns a map or other JSON-compatible data structure that can be passed
  to `Jason.encode/1` or similar JSON encoding functions.
  """
  @spec to_encodable(t()) :: map() | list() | binary() | number() | boolean() | nil
  def to_encodable(data)
end

defimpl SBoM.CycloneDX.JSON.Encodable, for: Any do
  alias SBoM.CycloneDX.JSON.Encoder

  @impl SBoM.CycloneDX.JSON.Encodable
  def to_encodable(%module{} = struct) do
    true = function_exported?(module, :__message_props__, 0)
    Encoder.encodable(struct)
  end
end

defimpl SBoM.CycloneDX.JSON.Encodable,
  for: [
    Google.Protobuf.FieldMask,
    Google.Protobuf.Duration,
    Google.Protobuf.Timestamp,
    Google.Protobuf.BytesValue,
    Google.Protobuf.Struct,
    Google.Protobuf.ListValue,
    Google.Protobuf.Value,
    Google.Protobuf.Empty,
    Google.Protobuf.Int32Value,
    Google.Protobuf.UInt32Value,
    Google.Protobuf.UInt64Value,
    Google.Protobuf.Int64Value,
    Google.Protobuf.FloatValue,
    Google.Protobuf.DoubleValue,
    Google.Protobuf.BoolValue,
    Google.Protobuf.StringValue,
    Google.Protobuf.Any
  ] do
  @impl SBoM.CycloneDX.JSON.Encodable
  def to_encodable(struct) do
    {:ok, encoded} = Protobuf.JSON.to_encodable(struct, [])
    encoded
  end
end

defimpl SBoM.CycloneDX.JSON.Encodable,
  for: [
    SBoM.Cyclonedx.V17.Component,
    SBoM.Cyclonedx.V16.Component,
    SBoM.Cyclonedx.V15.Component,
    SBoM.Cyclonedx.V14.Component,
    SBoM.Cyclonedx.V13.Component
  ] do
  alias SBoM.CycloneDX.JSON.Encoder

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

  @impl SBoM.CycloneDX.JSON.Encodable
  def to_encodable(component) do
    component
    |> Encoder.encodable()
    |> Map.update("type", nil, &classification_to_string/1)
    |> Map.update("scope", nil, &scope_to_string/1)
    |> rename_bom_ref()
  end

  @spec rename_bom_ref(map()) :: map()
  defp rename_bom_ref(map) do
    case Map.pop(map, "bomRef") do
      {nil, map} -> map
      {bom_ref, map} -> Map.put(map, "bom-ref", bom_ref)
    end
  end

  @spec classification_to_string(classification()) :: String.t() | nil
  defp classification_to_string(:CLASSIFICATION_NULL), do: nil
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

defimpl SBoM.CycloneDX.JSON.Encodable,
  for: [
    SBoM.Cyclonedx.V17.Hash,
    SBoM.Cyclonedx.V16.Hash,
    SBoM.Cyclonedx.V15.Hash,
    SBoM.Cyclonedx.V14.Hash,
    SBoM.Cyclonedx.V13.Hash
  ] do
  alias SBoM.CycloneDX.JSON.Encoder

  @type hash_alg() ::
          SBoM.Cyclonedx.V13.HashAlg.t()
          | SBoM.Cyclonedx.V14.HashAlg.t()
          | SBoM.Cyclonedx.V15.HashAlg.t()
          | SBoM.Cyclonedx.V16.HashAlg.t()
          | SBoM.Cyclonedx.V17.HashAlg.t()

  @impl SBoM.CycloneDX.JSON.Encodable
  def to_encodable(hash) do
    hash
    |> Encoder.encodable()
    |> Map.update("alg", nil, &hash_alg_to_string/1)
    |> rename_value_to_content()
  end

  @spec rename_value_to_content(map()) :: map()
  defp rename_value_to_content(map) do
    case Map.pop(map, "value") do
      {nil, map} -> map
      {value, map} -> Map.put(map, "content", value)
    end
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

defimpl SBoM.CycloneDX.JSON.Encodable,
  for: [
    SBoM.Cyclonedx.V17.ExternalReference,
    SBoM.Cyclonedx.V16.ExternalReference,
    SBoM.Cyclonedx.V15.ExternalReference,
    SBoM.Cyclonedx.V14.ExternalReference,
    SBoM.Cyclonedx.V13.ExternalReference
  ] do
  alias SBoM.CycloneDX.JSON.Encoder

  @type external_reference_type() ::
          SBoM.Cyclonedx.V13.ExternalReferenceType.t()
          | SBoM.Cyclonedx.V14.ExternalReferenceType.t()
          | SBoM.Cyclonedx.V15.ExternalReferenceType.t()
          | SBoM.Cyclonedx.V16.ExternalReferenceType.t()
          | SBoM.Cyclonedx.V17.ExternalReferenceType.t()

  @impl SBoM.CycloneDX.JSON.Encodable
  def to_encodable(external_reference) do
    external_reference
    |> Encoder.encodable()
    |> Map.update("type", nil, &external_reference_type_to_string/1)
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

defimpl SBoM.CycloneDX.JSON.Encodable,
  for: [
    SBoM.Cyclonedx.V17.Dependency,
    SBoM.Cyclonedx.V16.Dependency,
    SBoM.Cyclonedx.V15.Dependency,
    SBoM.Cyclonedx.V14.Dependency,
    SBoM.Cyclonedx.V13.Dependency
  ] do
  alias SBoM.CycloneDX.JSON.Encoder

  @impl SBoM.CycloneDX.JSON.Encodable
  def to_encodable(dependency) do
    dependency
    |> Encoder.encodable()
    |> rename_dependencies_to_depends_on()
  end

  @spec rename_dependencies_to_depends_on(map()) :: map()
  defp rename_dependencies_to_depends_on(map) do
    case Map.pop(map, "dependencies") do
      {nil, map} ->
        map

      {[], map} ->
        map

      {dependencies, map} ->
        depends_on = Enum.map(dependencies, fn %{"ref" => ref} -> ref end)
        Map.put(map, "dependsOn", depends_on)
    end
  end
end

defimpl SBoM.CycloneDX.JSON.Encodable,
  for: [
    SBoM.Cyclonedx.V17.Bom,
    SBoM.Cyclonedx.V16.Bom,
    SBoM.Cyclonedx.V15.Bom,
    SBoM.Cyclonedx.V14.Bom,
    SBoM.Cyclonedx.V13.Bom
  ] do
  alias SBoM.CycloneDX.JSON.Encoder

  @impl SBoM.CycloneDX.JSON.Encodable
  def to_encodable(bom) do
    encoded = Encoder.encodable(bom)
    Map.put(encoded, "bomFormat", "CycloneDX")
  end
end
