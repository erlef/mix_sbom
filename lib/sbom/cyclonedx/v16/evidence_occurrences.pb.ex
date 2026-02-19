defmodule SBoM.CycloneDX.V16.EvidenceOccurrences do
  @moduledoc "CycloneDX EvidenceOccurrences model."
  use Protobuf,
    full_name: "cyclonedx.v1_6.EvidenceOccurrences",
    protoc_gen_elixir_version: "0.16.0",
    syntax: :proto3

  field(:bom_ref, 1, proto3_optional: true, type: :string, json_name: "bomRef")
  field(:location, 2, type: :string)
  field(:line, 3, proto3_optional: true, type: :int32)
  field(:offset, 4, proto3_optional: true, type: :int32)
  field(:symbol, 5, proto3_optional: true, type: :string)
  field(:additionalContext, 6, proto3_optional: true, type: :string)
end
