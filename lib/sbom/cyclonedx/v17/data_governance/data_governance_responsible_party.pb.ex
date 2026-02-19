defmodule SBoM.CycloneDX.V17.DataGovernance.DataGovernanceResponsibleParty do
  @moduledoc "CycloneDX DataGovernance.DataGovernanceResponsibleParty model."
  use Protobuf,
    full_name: "cyclonedx.v1_7.DataGovernance.DataGovernanceResponsibleParty",
    protoc_gen_elixir_version: "0.16.0",
    syntax: :proto3

  oneof(:choice, 0)

  field(:organization, 1, type: SBoM.CycloneDX.V17.OrganizationalEntity, oneof: 0)
  field(:contact, 2, type: SBoM.CycloneDX.V17.OrganizationalContact, oneof: 0)
end
