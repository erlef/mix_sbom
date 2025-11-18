defmodule SBoM.Cyclonedx.V16.CO2MeasureType.CO2MeasureUnitType do
  @moduledoc false

  use Protobuf, enum: true, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field(:CO2_MEASURE_UNIT_TYPE_UNSPECIFIED, 0)
  field(:CO2_MEASURE_UNIT_TYPE_TONNES_CO2_EQUIVALENT, 1)
end
