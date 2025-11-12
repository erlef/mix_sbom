defmodule SBoM.Cyclonedx.V17.DataGovernance.DataGovernanceResponsibleParty do
  @moduledoc false

  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  oneof(:choice, 0)

  field(:organization, 1, type: SBoM.Cyclonedx.V17.OrganizationalEntity, oneof: 0)
  field(:contact, 2, type: SBoM.Cyclonedx.V17.OrganizationalContact, oneof: 0)
end
