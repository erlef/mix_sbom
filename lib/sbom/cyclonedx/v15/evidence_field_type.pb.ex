defmodule SBoM.CycloneDX.V15.EvidenceFieldType do
  @moduledoc "CycloneDX EvidenceFieldType model."
  use Protobuf,
    enum: true,
    full_name: "cyclonedx.v1_5.EvidenceFieldType",
    protoc_gen_elixir_version: "0.16.0",
    syntax: :proto3

  field(:EVIDENCE_FIELD_NULL, 0)
  field(:EVIDENCE_FIELD_GROUP, 1)
  field(:EVIDENCE_FIELD_NAME, 2)
  field(:EVIDENCE_FIELD_VERSION, 3)
  field(:EVIDENCE_FIELD_PURL, 4)
  field(:EVIDENCE_FIELD_CPE, 5)
  field(:EVIDENCE_FIELD_SWID, 6)
  field(:EVIDENCE_FIELD_HASH, 7)
end
