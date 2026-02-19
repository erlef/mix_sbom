defmodule SBoM.CycloneDX.V17.EvidenceIdentity do
  @moduledoc "CycloneDX EvidenceIdentity model."
  use Protobuf,
    full_name: "cyclonedx.v1_7.EvidenceIdentity",
    protoc_gen_elixir_version: "0.16.0",
    syntax: :proto3

  field(:field, 1, type: SBoM.CycloneDX.V17.EvidenceFieldType, enum: true)
  field(:confidence, 2, proto3_optional: true, type: :float)
  field(:methods, 3, repeated: true, type: SBoM.CycloneDX.V17.EvidenceMethods)
  field(:tools, 4, repeated: true, type: :string)
  field(:concludedValue, 5, proto3_optional: true, type: :string)
end
