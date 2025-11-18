defmodule SBoM.Cyclonedx.V15.OrganizationalEntityOrContact do
  @moduledoc false

  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  oneof(:choice, 0)

  field(:organization, 1, type: SBoM.Cyclonedx.V15.OrganizationalEntity, oneof: 0)
  field(:individual, 2, type: SBoM.Cyclonedx.V15.OrganizationalContact, oneof: 0)
end
