defmodule SBoM.CycloneDX.V16.EnergyProviderType do
  @moduledoc """
  Describes the physical provider of energy used for model development or operations.
  """

  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field(:bom_ref, 1, proto3_optional: true, type: :string, json_name: "bomRef")
  field(:description, 2, type: :string)
  field(:organization, 3, type: SBoM.CycloneDX.V16.OrganizationalEntity)

  field(:energySource, 4,
    type: SBoM.CycloneDX.V16.EnergyProviderType.EnergySourceType,
    enum: true
  )

  field(:energyProvided, 5, type: SBoM.CycloneDX.V16.EnergyMeasureType)

  field(:external_references, 6,
    repeated: true,
    type: SBoM.CycloneDX.V16.ExternalReference,
    json_name: "externalReferences"
  )
end
