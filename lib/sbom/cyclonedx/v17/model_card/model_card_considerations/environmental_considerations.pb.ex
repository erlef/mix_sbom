defmodule SBoM.Cyclonedx.V17.ModelCard.ModelCardConsiderations.EnvironmentalConsiderations do
  @moduledoc false

  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field(:energyConsumptions, 1,
    repeated: true,
    type: SBoM.Cyclonedx.V17.ModelCard.ModelCardConsiderations.EnergyConsumption
  )

  field(:properties, 2, repeated: true, type: SBoM.Cyclonedx.V17.Property)
end
