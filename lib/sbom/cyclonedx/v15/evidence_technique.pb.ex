defmodule SBoM.CycloneDX.V15.EvidenceTechnique do
  @moduledoc "CycloneDX EvidenceTechnique model."
  use Protobuf,
    enum: true,
    full_name: "cyclonedx.v1_5.EvidenceTechnique",
    protoc_gen_elixir_version: "0.16.0",
    syntax: :proto3

  field(:EVIDENCE_TECHNIQUE_SOURCE_CODE_ANALYSIS, 0)
  field(:EVIDENCE_TECHNIQUE_BINARY_ANALYSIS, 1)
  field(:EVIDENCE_TECHNIQUE_MANIFEST_ANALYSIS, 2)
  field(:EVIDENCE_TECHNIQUE_AST_FINGERPRINT, 3)
  field(:EVIDENCE_TECHNIQUE_HASH_COMPARISON, 4)
  field(:EVIDENCE_TECHNIQUE_INSTRUMENTATION, 5)
  field(:EVIDENCE_TECHNIQUE_DYNAMIC_ANALYSIS, 6)
  field(:EVIDENCE_TECHNIQUE_FILENAME, 7)
  field(:EVIDENCE_TECHNIQUE_ATTESTATION, 8)
  field(:EVIDENCE_TECHNIQUE_OTHER, 9)
end
