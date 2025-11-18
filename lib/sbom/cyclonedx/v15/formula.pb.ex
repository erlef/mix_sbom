defmodule SBoM.Cyclonedx.V15.Formula do
  @moduledoc false

  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field(:bom_ref, 1, proto3_optional: true, type: :string, json_name: "bomRef")
  field(:components, 2, repeated: true, type: SBoM.Cyclonedx.V15.Component)
  field(:services, 3, repeated: true, type: SBoM.Cyclonedx.V15.Service)
  field(:workflows, 4, repeated: true, type: SBoM.Cyclonedx.V15.Workflow)
  field(:properties, 5, repeated: true, type: SBoM.Cyclonedx.V15.Property)
end
