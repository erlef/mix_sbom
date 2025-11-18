defmodule SBoM.Cyclonedx.V16.EnergyMeasureType.EnergyMeasureUnitType do
  @moduledoc false

  use Protobuf, enum: true, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field(:ENERGY_MEASURE_UNIT_TYPE_UNSPECIFIED, 0)
  field(:ENERGY_MEASURE_UNIT_TYPE_KILOWATT_HOURS, 1)
end
