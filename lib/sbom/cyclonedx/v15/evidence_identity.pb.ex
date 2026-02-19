defmodule SBoM.CycloneDX.V15.EvidenceIdentity do
  @moduledoc "CycloneDX EvidenceIdentity model."
  use Protobuf,
    full_name: "cyclonedx.v1_5.EvidenceIdentity",
    protoc_gen_elixir_version: "0.16.0",
    syntax: :proto3

  field(:field, 1, type: SBoM.CycloneDX.V15.EvidenceFieldType, enum: true)
  field(:confidence, 2, proto3_optional: true, type: :float)
  field(:methods, 3, repeated: true, type: SBoM.CycloneDX.V15.EvidenceMethods)
  field(:tools, 4, repeated: true, type: :string)
end
