defmodule SBoM.Cyclonedx.V17.InputType do
  @moduledoc false

  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field(:source, 1, proto3_optional: true, type: SBoM.Cyclonedx.V17.ResourceReferenceChoice)
  field(:target, 2, proto3_optional: true, type: SBoM.Cyclonedx.V17.ResourceReferenceChoice)
  field(:resource, 3, proto3_optional: true, type: SBoM.Cyclonedx.V17.ResourceReferenceChoice)
  field(:parameters, 4, repeated: true, type: SBoM.Cyclonedx.V17.Parameter)
  field(:environmentVars, 5, repeated: true, type: SBoM.Cyclonedx.V17.EnvironmentVars)
  field(:data, 6, proto3_optional: true, type: SBoM.Cyclonedx.V17.AttachedText)
  field(:properties, 7, repeated: true, type: SBoM.Cyclonedx.V17.Property)
end
