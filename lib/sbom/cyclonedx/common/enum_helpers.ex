# SPDX-License-Identifier: BSD-3-Clause
# SPDX-FileCopyrightText: 2025 Erlang Ecosystem Foundation

defmodule SBoM.CycloneDX.Common.EnumHelpers do
  @moduledoc false

  @type hash_alg() ::
          SBoM.CycloneDX.V13.HashAlg.t()
          | SBoM.CycloneDX.V14.HashAlg.t()
          | SBoM.CycloneDX.V15.HashAlg.t()
          | SBoM.CycloneDX.V16.HashAlg.t()
          | SBoM.CycloneDX.V17.HashAlg.t()

  @type external_reference_type() ::
          SBoM.CycloneDX.V13.ExternalReferenceType.t()
          | SBoM.CycloneDX.V14.ExternalReferenceType.t()
          | SBoM.CycloneDX.V15.ExternalReferenceType.t()
          | SBoM.CycloneDX.V16.ExternalReferenceType.t()
          | SBoM.CycloneDX.V17.ExternalReferenceType.t()

  @type classification() ::
          SBoM.CycloneDX.V13.Classification.t()
          | SBoM.CycloneDX.V14.Classification.t()
          | SBoM.CycloneDX.V15.Classification.t()
          | SBoM.CycloneDX.V16.Classification.t()
          | SBoM.CycloneDX.V17.Classification.t()

  @type scope() ::
          SBoM.CycloneDX.V13.Scope.t()
          | SBoM.CycloneDX.V14.Scope.t()
          | SBoM.CycloneDX.V15.Scope.t()
          | SBoM.CycloneDX.V16.Scope.t()
          | SBoM.CycloneDX.V17.Scope.t()

  @hash_alg_mappings %{
    HASH_ALG_NULL: "",
    HASH_ALG_MD_5: "MD5",
    HASH_ALG_SHA_1: "SHA-1",
    HASH_ALG_SHA_256: "SHA-256",
    HASH_ALG_SHA_384: "SHA-384",
    HASH_ALG_SHA_512: "SHA-512",
    HASH_ALG_SHA_3_256: "SHA3-256",
    HASH_ALG_SHA_3_384: "SHA3-384",
    HASH_ALG_SHA_3_512: "SHA3-512",
    HASH_ALG_BLAKE_2_B_256: "BLAKE2b-256",
    HASH_ALG_BLAKE_2_B_384: "BLAKE2b-384",
    HASH_ALG_BLAKE_2_B_512: "BLAKE2b-512",
    HASH_ALG_BLAKE_3: "BLAKE3",
    HASH_ALG_STREEBOG_256: "Streebog-256",
    HASH_ALG_STREEBOG_512: "Streebog-512"
  }

  @external_reference_type_mappings %{
    EXTERNAL_REFERENCE_TYPE_OTHER: "other",
    EXTERNAL_REFERENCE_TYPE_VCS: "vcs",
    EXTERNAL_REFERENCE_TYPE_ISSUE_TRACKER: "issue-tracker",
    EXTERNAL_REFERENCE_TYPE_WEBSITE: "website",
    EXTERNAL_REFERENCE_TYPE_ADVISORIES: "advisories",
    EXTERNAL_REFERENCE_TYPE_BOM: "bom",
    EXTERNAL_REFERENCE_TYPE_MAILING_LIST: "mailing-list",
    EXTERNAL_REFERENCE_TYPE_SOCIAL: "social",
    EXTERNAL_REFERENCE_TYPE_CHAT: "chat",
    EXTERNAL_REFERENCE_TYPE_DOCUMENTATION: "documentation",
    EXTERNAL_REFERENCE_TYPE_SUPPORT: "support",
    EXTERNAL_REFERENCE_TYPE_SOURCE_DISTRIBUTION: "source-distribution",
    EXTERNAL_REFERENCE_TYPE_DISTRIBUTION: "distribution",
    EXTERNAL_REFERENCE_TYPE_DISTRIBUTION_INTAKE: "distribution-intake",
    EXTERNAL_REFERENCE_TYPE_LICENSE: "license",
    EXTERNAL_REFERENCE_TYPE_BUILD_META: "build-meta",
    EXTERNAL_REFERENCE_TYPE_BUILD_SYSTEM: "build-system",
    EXTERNAL_REFERENCE_TYPE_RELEASE_NOTES: "release-notes",
    EXTERNAL_REFERENCE_TYPE_SECURITY_CONTACT: "security-contact",
    EXTERNAL_REFERENCE_TYPE_MODEL_CARD: "model-card",
    EXTERNAL_REFERENCE_TYPE_LOG: "log",
    EXTERNAL_REFERENCE_TYPE_CONFIGURATION: "configuration",
    EXTERNAL_REFERENCE_TYPE_EVIDENCE: "evidence",
    EXTERNAL_REFERENCE_TYPE_FORMULATION: "formulation",
    EXTERNAL_REFERENCE_TYPE_ATTESTATION: "attestation",
    EXTERNAL_REFERENCE_TYPE_THREAT_MODEL: "threat-model",
    EXTERNAL_REFERENCE_TYPE_ADVERSARY_MODEL: "adversary-model",
    EXTERNAL_REFERENCE_TYPE_RISK_ASSESSMENT: "risk-assessment",
    EXTERNAL_REFERENCE_TYPE_VULNERABILITY_ASSERTION: "vulnerability-assertion",
    EXTERNAL_REFERENCE_TYPE_EXPLOITABILITY_STATEMENT: "exploitability-statement",
    EXTERNAL_REFERENCE_TYPE_PENTEST_REPORT: "pentest-report",
    EXTERNAL_REFERENCE_TYPE_STATIC_ANALYSIS_REPORT: "static-analysis-report",
    EXTERNAL_REFERENCE_TYPE_DYNAMIC_ANALYSIS_REPORT: "dynamic-analysis-report",
    EXTERNAL_REFERENCE_TYPE_RUNTIME_ANALYSIS_REPORT: "runtime-analysis-report",
    EXTERNAL_REFERENCE_TYPE_COMPONENT_ANALYSIS_REPORT: "component-analysis-report",
    EXTERNAL_REFERENCE_TYPE_MATURITY_REPORT: "maturity-report",
    EXTERNAL_REFERENCE_TYPE_CERTIFICATION_REPORT: "certification-report",
    EXTERNAL_REFERENCE_TYPE_QUALITY_METRICS: "quality-metrics",
    EXTERNAL_REFERENCE_TYPE_CODIFIED_INFRASTRUCTURE: "codified-infrastructure",
    EXTERNAL_REFERENCE_TYPE_POAM: "poam",
    EXTERNAL_REFERENCE_TYPE_ELECTRONIC_SIGNATURE: "electronic-signature",
    EXTERNAL_REFERENCE_TYPE_DIGITAL_SIGNATURE: "digital-signature",
    EXTERNAL_REFERENCE_TYPE_RFC_9116: "rfc-9116",
    EXTERNAL_REFERENCE_TYPE_PATENT: "patent",
    EXTERNAL_REFERENCE_TYPE_PATENT_FAMILY: "patent-family",
    EXTERNAL_REFERENCE_TYPE_PATENT_ASSERTION: "patent-assertion",
    EXTERNAL_REFERENCE_TYPE_CITATION: "citation"
  }

  @classification_mappings %{
    CLASSIFICATION_NULL: nil,
    CLASSIFICATION_APPLICATION: "application",
    CLASSIFICATION_FRAMEWORK: "framework",
    CLASSIFICATION_LIBRARY: "library",
    CLASSIFICATION_OPERATING_SYSTEM: "operating-system",
    CLASSIFICATION_DEVICE: "device",
    CLASSIFICATION_FILE: "file",
    CLASSIFICATION_CONTAINER: "container",
    CLASSIFICATION_FIRMWARE: "firmware",
    CLASSIFICATION_DEVICE_DRIVER: "device-driver",
    CLASSIFICATION_PLATFORM: "platform",
    CLASSIFICATION_MACHINE_LEARNING_MODEL: "machine-learning-model",
    CLASSIFICATION_DATA: "data",
    CLASSIFICATION_CRYPTOGRAPHIC_ASSET: "cryptographic-asset"
  }

  @scope_mappings %{
    SCOPE_UNSPECIFIED: nil,
    SCOPE_REQUIRED: "required",
    SCOPE_OPTIONAL: "optional",
    SCOPE_EXCLUDED: "excluded"
  }

  @spec hash_alg_to_string(hash_alg()) :: String.t()
  for {enum_value, string_value} <- @hash_alg_mappings do
    def hash_alg_to_string(unquote(enum_value)), do: unquote(string_value)
  end

  @spec external_reference_type_to_string(external_reference_type()) :: String.t()
  for {enum_value, string_value} <- @external_reference_type_mappings do
    def external_reference_type_to_string(unquote(enum_value)), do: unquote(string_value)
  end

  @spec classification_to_string(classification()) :: String.t() | nil
  for {enum_value, string_value} <- @classification_mappings do
    def classification_to_string(unquote(enum_value)), do: unquote(string_value)
  end

  # Note: For XML encoding, this returns "" for :CLASSIFICATION_NULL instead of nil
  @spec classification_to_string_xml(classification()) :: String.t()
  def classification_to_string_xml(:CLASSIFICATION_NULL), do: ""
  def classification_to_string_xml(type), do: classification_to_string(type) || ""

  @spec scope_to_string(scope() | nil) :: String.t() | nil
  for {enum_value, string_value} <- @scope_mappings do
    def scope_to_string(unquote(enum_value)), do: unquote(string_value)
  end

  def scope_to_string(nil), do: nil

  # Reverse mappings for decoding strings back to enums
  @spec string_to_hash_alg(String.t()) :: hash_alg() | nil
  for {enum_value, string_value} <- @hash_alg_mappings, string_value != "" do
    def string_to_hash_alg(unquote(string_value)), do: unquote(enum_value)
  end

  def string_to_hash_alg(""), do: :HASH_ALG_NULL
  def string_to_hash_alg(_unknown_string), do: nil

  @spec string_to_external_reference_type(String.t()) :: external_reference_type() | nil
  for {enum_value, string_value} <- @external_reference_type_mappings do
    def string_to_external_reference_type(unquote(string_value)), do: unquote(enum_value)
  end

  def string_to_external_reference_type(_unknown_string), do: nil

  @spec string_to_classification(String.t()) :: classification() | nil
  for {enum_value, string_value} <- @classification_mappings, not is_nil(string_value) do
    def string_to_classification(unquote(string_value)), do: unquote(enum_value)
  end

  def string_to_classification(""), do: :CLASSIFICATION_NULL
  def string_to_classification(_unknown_string), do: nil

  @spec string_to_scope(String.t()) :: scope() | nil
  for {enum_value, string_value} <- @scope_mappings, not is_nil(string_value) do
    def string_to_scope(unquote(string_value)), do: unquote(enum_value)
  end

  def string_to_scope(_unknown_string), do: nil
end
