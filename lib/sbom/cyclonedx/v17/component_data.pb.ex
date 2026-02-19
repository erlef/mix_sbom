defmodule SBoM.CycloneDX.V17.ComponentData do
  @moduledoc "CycloneDX ComponentData model."
  use Protobuf,
    full_name: "cyclonedx.v1_7.ComponentData",
    protoc_gen_elixir_version: "0.16.0",
    syntax: :proto3

  field(:bom_ref, 1, proto3_optional: true, type: :string, json_name: "bomRef")
  field(:type, 2, type: SBoM.CycloneDX.V17.ComponentDataType, enum: true)
  field(:name, 3, proto3_optional: true, type: :string)

  field(:contents, 4,
    proto3_optional: true,
    type: SBoM.CycloneDX.V17.ComponentData.ComponentDataContents
  )

  field(:classification, 5, proto3_optional: true, type: :string)
  field(:sensitiveData, 6, repeated: true, type: :string)
  field(:graphics, 7, proto3_optional: true, type: SBoM.CycloneDX.V17.GraphicsCollection)
  field(:description, 8, proto3_optional: true, type: :string)
  field(:governance, 9, proto3_optional: true, type: SBoM.CycloneDX.V17.DataGovernance)
end
