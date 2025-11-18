defmodule SBoM.Cyclonedx.V16.DataGovernance do
  @moduledoc false

  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  alias SBoM.Cyclonedx.V16.DataGovernance.DataGovernanceResponsibleParty

  field(:custodians, 1,
    repeated: true,
    type: DataGovernanceResponsibleParty
  )

  field(:stewards, 2,
    repeated: true,
    type: DataGovernanceResponsibleParty
  )

  field(:owners, 3,
    repeated: true,
    type: DataGovernanceResponsibleParty
  )
end
