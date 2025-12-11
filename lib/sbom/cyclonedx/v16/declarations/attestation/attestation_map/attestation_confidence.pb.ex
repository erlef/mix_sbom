defmodule SBoM.CycloneDX.V16.Declarations.Attestation.AttestationMap.AttestationConfidence do
  @moduledoc """
  Confidence
  """

  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field(:score, 1, proto3_optional: true, type: :double)
  field(:rationale, 2, proto3_optional: true, type: :string)
end
