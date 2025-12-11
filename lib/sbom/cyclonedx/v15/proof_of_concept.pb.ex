defmodule SBoM.CycloneDX.V15.ProofOfConcept do
  @moduledoc "CycloneDX ProofOfConcept model."
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field(:reproductionSteps, 1, proto3_optional: true, type: :string)
  field(:environment, 2, proto3_optional: true, type: :string)
  field(:supportingMaterial, 3, repeated: true, type: SBoM.CycloneDX.V15.AttachedText)
end
