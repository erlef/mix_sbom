defmodule SBoM.Cyclonedx.V15.ComponentData do
  @moduledoc false

  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field(:bom_ref, 1, proto3_optional: true, type: :string, json_name: "bomRef")
  field(:type, 2, type: SBoM.Cyclonedx.V15.ComponentDataType, enum: true)
  field(:name, 3, proto3_optional: true, type: :string)

  field(:contents, 4,
    proto3_optional: true,
    type: SBoM.Cyclonedx.V15.ComponentData.ComponentDataContents
  )

  field(:classification, 5, proto3_optional: true, type: :string)
  field(:sensitiveData, 6, repeated: true, type: :string)
  field(:graphics, 7, proto3_optional: true, type: SBoM.Cyclonedx.V15.GraphicsCollection)
  field(:description, 8, proto3_optional: true, type: :string)
  field(:governance, 9, proto3_optional: true, type: SBoM.Cyclonedx.V15.DataGovernance)
end
