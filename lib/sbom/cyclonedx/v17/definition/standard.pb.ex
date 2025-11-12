defmodule SBoM.Cyclonedx.V17.Definition.Standard do
  @moduledoc false

  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field(:bom_ref, 1, proto3_optional: true, type: :string, json_name: "bomRef")
  field(:name, 2, proto3_optional: true, type: :string)
  field(:version, 3, proto3_optional: true, type: :string)
  field(:description, 4, proto3_optional: true, type: :string)
  field(:owner, 5, proto3_optional: true, type: :string)

  field(:requirements, 6,
    repeated: true,
    type: SBoM.Cyclonedx.V17.Definition.Standard.Requirement
  )

  field(:levels, 7, repeated: true, type: SBoM.Cyclonedx.V17.Definition.Standard.Level)
  field(:externalReferences, 8, repeated: true, type: SBoM.Cyclonedx.V17.ExternalReference)
end
