defmodule SBoM.CycloneDX.V17.DataGovernance do
  @moduledoc """
  Data governance captures information regarding data ownership, stewardship, and custodianship, providing insights into the individuals or entities responsible for managing, overseeing, and safeguarding the data throughout its lifecycle.
  """

  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  alias SBoM.CycloneDX.V17.DataGovernance.DataGovernanceResponsibleParty

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
