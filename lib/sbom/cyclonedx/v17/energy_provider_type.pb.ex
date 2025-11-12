defmodule SBoM.Cyclonedx.V17.EnergyProviderType do
  @moduledoc false

  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field(:bom_ref, 1, proto3_optional: true, type: :string, json_name: "bomRef")
  field(:description, 2, type: :string)
  field(:organization, 3, type: SBoM.Cyclonedx.V17.OrganizationalEntity)

  field(:energySource, 4,
    type: SBoM.Cyclonedx.V17.EnergyProviderType.EnergySourceType,
    enum: true
  )

  field(:energyProvided, 5, type: SBoM.Cyclonedx.V17.EnergyMeasureType)

  field(:external_references, 6,
    repeated: true,
    type: SBoM.Cyclonedx.V17.ExternalReference,
    json_name: "externalReferences"
  )
end
