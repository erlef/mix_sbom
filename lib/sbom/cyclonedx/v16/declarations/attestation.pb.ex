defmodule SBoM.Cyclonedx.V16.Declarations.Attestation do
  @moduledoc false

  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field(:summary, 1, proto3_optional: true, type: :string)
  field(:assessor, 2, proto3_optional: true, type: :string)
  field(:map, 3, repeated: true, type: SBoM.Cyclonedx.V16.Declarations.Attestation.AttestationMap)
end
