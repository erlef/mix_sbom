defmodule SBoM.CycloneDX.V17.ModelCard.ModelCardConsiderations.EnvironmentalConsiderations do
  @moduledoc "CycloneDX ModelCard.ModelCardConsiderations.EnvironmentalConsiderations model."
  use Protobuf,
    full_name: "cyclonedx.v1_7.ModelCard.ModelCardConsiderations.EnvironmentalConsiderations",
    protoc_gen_elixir_version: "0.16.0",
    syntax: :proto3

  field(:energyConsumptions, 1,
    repeated: true,
    type: SBoM.CycloneDX.V17.ModelCard.ModelCardConsiderations.EnergyConsumption
  )

  field(:properties, 2, repeated: true, type: SBoM.CycloneDX.V17.Property)
end
