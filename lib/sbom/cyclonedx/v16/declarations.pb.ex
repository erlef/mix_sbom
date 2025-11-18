defmodule SBoM.Cyclonedx.V16.Declarations do
  @moduledoc false

  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field(:assessors, 1, repeated: true, type: SBoM.Cyclonedx.V16.Declarations.Assessor)
  field(:attestations, 2, repeated: true, type: SBoM.Cyclonedx.V16.Declarations.Attestation)
  field(:claims, 3, repeated: true, type: SBoM.Cyclonedx.V16.Declarations.Claim)
  field(:evidence, 4, repeated: true, type: SBoM.Cyclonedx.V16.Declarations.Evidence)
  field(:targets, 5, proto3_optional: true, type: SBoM.Cyclonedx.V16.Declarations.Targets)
  field(:affirmation, 6, proto3_optional: true, type: SBoM.Cyclonedx.V16.Declarations.Affirmation)
end
