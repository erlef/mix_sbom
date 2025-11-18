defmodule SBoM.Cyclonedx.V16.InputType do
  @moduledoc false

  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  alias SBoM.Cyclonedx.V16.ResourceReferenceChoice

  field(:source, 1, proto3_optional: true, type: ResourceReferenceChoice)
  field(:target, 2, proto3_optional: true, type: ResourceReferenceChoice)
  field(:resource, 3, proto3_optional: true, type: ResourceReferenceChoice)
  field(:parameters, 4, repeated: true, type: SBoM.Cyclonedx.V16.Parameter)
  field(:environmentVars, 5, repeated: true, type: SBoM.Cyclonedx.V16.EnvironmentVars)
  field(:data, 6, proto3_optional: true, type: SBoM.Cyclonedx.V16.AttachedText)
  field(:properties, 7, repeated: true, type: SBoM.Cyclonedx.V16.Property)
end
