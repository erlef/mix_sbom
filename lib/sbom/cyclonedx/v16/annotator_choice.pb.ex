defmodule SBoM.Cyclonedx.V16.AnnotatorChoice do
  @moduledoc false

  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  oneof(:choice, 0)

  field(:organization, 1, type: SBoM.Cyclonedx.V16.OrganizationalEntity, oneof: 0)
  field(:individual, 2, type: SBoM.Cyclonedx.V16.OrganizationalContact, oneof: 0)
  field(:component, 3, type: SBoM.Cyclonedx.V16.Component, oneof: 0)
  field(:service, 4, type: SBoM.Cyclonedx.V16.Service, oneof: 0)
end
