defmodule SBoM.CycloneDX.V16.Declarations.Attestation do
  @moduledoc """
  Attestation
  """

  use Protobuf,
    full_name: "cyclonedx.v1_6.Declarations.Attestation",
    protoc_gen_elixir_version: "0.16.0",
    syntax: :proto3

  field(:summary, 1, proto3_optional: true, type: :string)
  field(:assessor, 2, proto3_optional: true, type: :string)
  field(:map, 3, repeated: true, type: SBoM.CycloneDX.V16.Declarations.Attestation.AttestationMap)
end
