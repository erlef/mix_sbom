defmodule SBoM.CycloneDX.V16.ModelCard.ModelCardConsiderations.EnvironmentalConsiderations do
  @moduledoc "CycloneDX ModelCard.ModelCardConsiderations.EnvironmentalConsiderations model."
  use Protobuf,
    full_name: "cyclonedx.v1_6.ModelCard.ModelCardConsiderations.EnvironmentalConsiderations",
    protoc_gen_elixir_version: "0.16.0",
    syntax: :proto3

  field(:energyConsumptions, 1,
    repeated: true,
    type: SBoM.CycloneDX.V16.ModelCard.ModelCardConsiderations.EnergyConsumption
  )

  field(:properties, 2, repeated: true, type: SBoM.CycloneDX.V16.Property)
end
