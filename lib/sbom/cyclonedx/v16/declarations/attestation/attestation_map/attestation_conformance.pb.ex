defmodule SBoM.CycloneDX.V16.Declarations.Attestation.AttestationMap.AttestationConformance do
  @moduledoc """
  Conformance
  """

  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field(:score, 1, proto3_optional: true, type: :double)
  field(:rationale, 2, proto3_optional: true, type: :string)
  field(:mitigationStrategies, 3, repeated: true, type: :string)
end
