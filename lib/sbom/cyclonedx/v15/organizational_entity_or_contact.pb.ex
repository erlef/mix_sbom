defmodule SBoM.CycloneDX.V15.OrganizationalEntityOrContact do
  @moduledoc "CycloneDX OrganizationalEntityOrContact model."
  use Protobuf,
    full_name: "cyclonedx.v1_5.OrganizationalEntityOrContact",
    protoc_gen_elixir_version: "0.16.0",
    syntax: :proto3

  oneof(:choice, 0)

  field(:organization, 1, type: SBoM.CycloneDX.V15.OrganizationalEntity, oneof: 0)
  field(:individual, 2, type: SBoM.CycloneDX.V15.OrganizationalContact, oneof: 0)
end
