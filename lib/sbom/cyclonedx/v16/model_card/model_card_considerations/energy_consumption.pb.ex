defmodule SBoM.Cyclonedx.V16.ModelCard.ModelCardConsiderations.EnergyConsumption do
  @moduledoc false

  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  alias SBoM.Cyclonedx.V16.CO2MeasureType

  field(:activity, 1,
    type: SBoM.Cyclonedx.V16.ModelCard.ModelCardConsiderations.EnergyConsumption.ActivityType,
    enum: true
  )

  field(:energyProviders, 2, repeated: true, type: SBoM.Cyclonedx.V16.EnergyProviderType)
  field(:activityEnergyCost, 3, type: SBoM.Cyclonedx.V16.EnergyMeasureType)
  field(:co2CostEquivalent, 4, proto3_optional: true, type: CO2MeasureType)
  field(:co2CostOffset, 5, proto3_optional: true, type: CO2MeasureType)
  field(:properties, 6, repeated: true, type: SBoM.Cyclonedx.V16.Property)
end
