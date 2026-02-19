defmodule SBoM.CycloneDX.V17.Declarations.Attestation.AttestationMap do
  @moduledoc """
  Map
  """

  use Protobuf,
    full_name: "cyclonedx.v1_7.Declarations.Attestation.AttestationMap",
    protoc_gen_elixir_version: "0.16.0",
    syntax: :proto3

  field(:requirement, 1, proto3_optional: true, type: :string)
  field(:claims, 2, repeated: true, type: :string)
  field(:counterClaims, 3, repeated: true, type: :string)

  field(:conformance, 4,
    proto3_optional: true,
    type: SBoM.CycloneDX.V17.Declarations.Attestation.AttestationMap.AttestationConformance
  )

  field(:confidence, 5,
    proto3_optional: true,
    type: SBoM.CycloneDX.V17.Declarations.Attestation.AttestationMap.AttestationConfidence
  )
end
