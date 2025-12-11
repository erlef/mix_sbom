defmodule SBoM.CycloneDX.V15.DataGovernance do
  @moduledoc "CycloneDX DataGovernance model."
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  alias SBoM.CycloneDX.V15.DataGovernance.DataGovernanceResponsibleParty

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
