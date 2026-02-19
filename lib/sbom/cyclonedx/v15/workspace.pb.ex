defmodule SBoM.CycloneDX.V15.Workspace do
  @moduledoc """
  A named filesystem or data resource shareable by workflow tasks.
  """

  use Protobuf,
    full_name: "cyclonedx.v1_5.Workspace",
    protoc_gen_elixir_version: "0.16.0",
    syntax: :proto3

  field(:bom_ref, 1, type: :string, json_name: "bomRef")
  field(:uid, 2, type: :string)
  field(:name, 3, proto3_optional: true, type: :string)
  field(:aliases, 4, repeated: true, type: :string)
  field(:description, 5, proto3_optional: true, type: :string)
  field(:properties, 6, repeated: true, type: SBoM.CycloneDX.V15.Property)
  field(:resourceReferences, 7, repeated: true, type: SBoM.CycloneDX.V15.ResourceReferenceChoice)

  field(:accessMode, 8,
    proto3_optional: true,
    type: SBoM.CycloneDX.V15.Workspace.AccessMode,
    enum: true
  )

  field(:mountPath, 9, proto3_optional: true, type: :string)
  field(:managedDataType, 10, proto3_optional: true, type: :string)
  field(:volumeRequest, 11, proto3_optional: true, type: :string)
  field(:volume, 12, proto3_optional: true, type: SBoM.CycloneDX.V15.Volume)
end
