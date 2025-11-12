defmodule SBoM.Cyclonedx.V17.CO2MeasureType do
  @moduledoc false

  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field(:value, 1, type: :float)
  field(:unit, 2, type: SBoM.Cyclonedx.V17.CO2MeasureType.CO2MeasureUnitType, enum: true)
end
