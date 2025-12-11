defmodule SBoM.CycloneDX.V16.OrganizationalEntityOrContact do
  @moduledoc """
  EITHER an organization OR an individual
  """

  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  oneof(:choice, 0)

  field(:organization, 1, type: SBoM.CycloneDX.V16.OrganizationalEntity, oneof: 0)
  field(:individual, 2, type: SBoM.CycloneDX.V16.OrganizationalContact, oneof: 0)
end
