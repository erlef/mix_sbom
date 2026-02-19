defmodule SBoM.CycloneDX.V16.EnergyMeasureType.EnergyMeasureUnitType do
  @moduledoc "CycloneDX EnergyMeasureType.EnergyMeasureUnitType model."
  use Protobuf,
    enum: true,
    full_name: "cyclonedx.v1_6.EnergyMeasureType.EnergyMeasureUnitType",
    protoc_gen_elixir_version: "0.16.0",
    syntax: :proto3

  field(:ENERGY_MEASURE_UNIT_TYPE_UNSPECIFIED, 0)
  field(:ENERGY_MEASURE_UNIT_TYPE_KILOWATT_HOURS, 1)
end
