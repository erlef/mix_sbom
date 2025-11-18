defmodule SBoM.Cyclonedx.V16.Declarations.Targets do
  @moduledoc false

  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field(:organizations, 1, repeated: true, type: SBoM.Cyclonedx.V16.OrganizationalEntity)
  field(:components, 2, repeated: true, type: SBoM.Cyclonedx.V16.Component)
  field(:services, 3, repeated: true, type: SBoM.Cyclonedx.V16.Service)
end
