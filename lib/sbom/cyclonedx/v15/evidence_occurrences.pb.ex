defmodule SBoM.CycloneDX.V15.EvidenceOccurrences do
  @moduledoc "CycloneDX EvidenceOccurrences model."
  use Protobuf,
    full_name: "cyclonedx.v1_5.EvidenceOccurrences",
    protoc_gen_elixir_version: "0.16.0",
    syntax: :proto3

  field(:bom_ref, 1, proto3_optional: true, type: :string, json_name: "bomRef")
  field(:location, 2, type: :string)
end
