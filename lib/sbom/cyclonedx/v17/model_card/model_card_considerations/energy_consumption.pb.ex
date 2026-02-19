defmodule SBoM.CycloneDX.V17.ModelCard.ModelCardConsiderations.EnergyConsumption do
  @moduledoc """
  Describes energy consumption information incurred for the specified lifecycle activity.
  """

  use Protobuf,
    full_name: "cyclonedx.v1_7.ModelCard.ModelCardConsiderations.EnergyConsumption",
    protoc_gen_elixir_version: "0.16.0",
    syntax: :proto3

  alias SBoM.CycloneDX.V17.CO2MeasureType

  field(:activity, 1,
    type: SBoM.CycloneDX.V17.ModelCard.ModelCardConsiderations.EnergyConsumption.ActivityType,
    enum: true
  )

  field(:energyProviders, 2, repeated: true, type: SBoM.CycloneDX.V17.EnergyProviderType)
  field(:activityEnergyCost, 3, type: SBoM.CycloneDX.V17.EnergyMeasureType)
  field(:co2CostEquivalent, 4, proto3_optional: true, type: CO2MeasureType)
  field(:co2CostOffset, 5, proto3_optional: true, type: CO2MeasureType)
  field(:properties, 6, repeated: true, type: SBoM.CycloneDX.V17.Property)
end
