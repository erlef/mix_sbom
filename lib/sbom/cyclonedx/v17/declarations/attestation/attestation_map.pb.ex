defmodule SBoM.Cyclonedx.V17.Declarations.Attestation.AttestationMap do
  @moduledoc false

  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field(:requirement, 1, proto3_optional: true, type: :string)
  field(:claims, 2, repeated: true, type: :string)
  field(:counterClaims, 3, repeated: true, type: :string)

  field(:conformance, 4,
    proto3_optional: true,
    type: SBoM.Cyclonedx.V17.Declarations.Attestation.AttestationMap.AttestationConformance
  )

  field(:confidence, 5,
    proto3_optional: true,
    type: SBoM.Cyclonedx.V17.Declarations.Attestation.AttestationMap.AttestationConfidence
  )
end
