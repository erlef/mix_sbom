defmodule SBoM.Cyclonedx.V15.OutputType do
  @moduledoc false

  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  alias SBoM.Cyclonedx.V15.ResourceReferenceChoice

  field(:type, 1,
    proto3_optional: true,
    type: SBoM.Cyclonedx.V15.OutputType.OutputTypeType,
    enum: true
  )

  field(:source, 2, proto3_optional: true, type: ResourceReferenceChoice)
  field(:target, 3, proto3_optional: true, type: ResourceReferenceChoice)
  field(:resource, 4, proto3_optional: true, type: ResourceReferenceChoice)
  field(:data, 5, proto3_optional: true, type: SBoM.Cyclonedx.V15.AttachedText)
  field(:environmentVars, 6, repeated: true, type: SBoM.Cyclonedx.V15.EnvironmentVars)
  field(:properties, 7, repeated: true, type: SBoM.Cyclonedx.V15.Property)
end
