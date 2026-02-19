defmodule SBoM.CycloneDX.V16.EnergyProviderType.EnergySourceType do
  @moduledoc "CycloneDX EnergyProviderType.EnergySourceType model."
  use Protobuf,
    enum: true,
    full_name: "cyclonedx.v1_6.EnergyProviderType.EnergySourceType",
    protoc_gen_elixir_version: "0.16.0",
    syntax: :proto3

  field(:ENERGY_SOURCE_TYPE_UNSPECIFIED, 0)
  field(:ENERGY_SOURCE_TYPE_UNKNOWN, 1)
  field(:ENERGY_SOURCE_TYPE_OTHER, 2)
  field(:ENERGY_SOURCE_TYPE_COAL, 3)
  field(:ENERGY_SOURCE_TYPE_OIL, 4)
  field(:ENERGY_SOURCE_TYPE_NATURAL_GAS, 5)
  field(:ENERGY_SOURCE_TYPE_NUCLEAR, 6)
  field(:ENERGY_SOURCE_TYPE_WIND, 7)
  field(:ENERGY_SOURCE_TYPE_SOLAR, 8)
  field(:ENERGY_SOURCE_TYPE_GEOTHERMAL, 9)
  field(:ENERGY_SOURCE_TYPE_HYDROPOWER, 10)
  field(:ENERGY_SOURCE_TYPE_BIOFUEL, 11)
end
