defmodule SBoM.CycloneDX.V17.EvidenceMethods do
  @moduledoc "CycloneDX EvidenceMethods model."
  use Protobuf,
    full_name: "cyclonedx.v1_7.EvidenceMethods",
    protoc_gen_elixir_version: "0.16.0",
    syntax: :proto3

  field(:technique, 1, type: SBoM.CycloneDX.V17.EvidenceTechnique, enum: true)
  field(:confidence, 2, type: :float)
  field(:value, 3, proto3_optional: true, type: :string)
end
