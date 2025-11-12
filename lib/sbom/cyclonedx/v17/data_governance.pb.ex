defmodule SBoM.Cyclonedx.V17.DataGovernance do
  @moduledoc false

  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field(:custodians, 1,
    repeated: true,
    type: SBoM.Cyclonedx.V17.DataGovernance.DataGovernanceResponsibleParty
  )

  field(:stewards, 2,
    repeated: true,
    type: SBoM.Cyclonedx.V17.DataGovernance.DataGovernanceResponsibleParty
  )

  field(:owners, 3,
    repeated: true,
    type: SBoM.Cyclonedx.V17.DataGovernance.DataGovernanceResponsibleParty
  )
end
