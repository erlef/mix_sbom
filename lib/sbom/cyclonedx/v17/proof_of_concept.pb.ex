defmodule SBoM.CycloneDX.V17.ProofOfConcept do
  @moduledoc "CycloneDX ProofOfConcept model."
  use Protobuf,
    full_name: "cyclonedx.v1_7.ProofOfConcept",
    protoc_gen_elixir_version: "0.16.0",
    syntax: :proto3

  field(:reproductionSteps, 1, proto3_optional: true, type: :string)
  field(:environment, 2, proto3_optional: true, type: :string)
  field(:supportingMaterial, 3, repeated: true, type: SBoM.CycloneDX.V17.AttachedText)
end
