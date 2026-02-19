defmodule SBoM.CycloneDX.V17.EnergyProviderType do
  @moduledoc """
  Describes the physical provider of energy used for model development or operations.
  """

  use Protobuf,
    full_name: "cyclonedx.v1_7.EnergyProviderType",
    protoc_gen_elixir_version: "0.16.0",
    syntax: :proto3

  field(:bom_ref, 1, proto3_optional: true, type: :string, json_name: "bomRef")
  field(:description, 2, type: :string)
  field(:organization, 3, type: SBoM.CycloneDX.V17.OrganizationalEntity)

  field(:energySource, 4,
    type: SBoM.CycloneDX.V17.EnergyProviderType.EnergySourceType,
    enum: true
  )

  field(:energyProvided, 5, type: SBoM.CycloneDX.V17.EnergyMeasureType)

  field(:external_references, 6,
    repeated: true,
    type: SBoM.CycloneDX.V17.ExternalReference,
    json_name: "externalReferences"
  )
end
