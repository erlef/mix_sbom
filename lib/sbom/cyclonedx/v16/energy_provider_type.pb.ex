defmodule SBoM.Cyclonedx.V16.EnergyProviderType do
  @moduledoc false

  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field(:bom_ref, 1, proto3_optional: true, type: :string, json_name: "bomRef")
  field(:description, 2, type: :string)
  field(:organization, 3, type: SBoM.Cyclonedx.V16.OrganizationalEntity)

  field(:energySource, 4,
    type: SBoM.Cyclonedx.V16.EnergyProviderType.EnergySourceType,
    enum: true
  )

  field(:energyProvided, 5, type: SBoM.Cyclonedx.V16.EnergyMeasureType)

  field(:external_references, 6,
    repeated: true,
    type: SBoM.Cyclonedx.V16.ExternalReference,
    json_name: "externalReferences"
  )
end
