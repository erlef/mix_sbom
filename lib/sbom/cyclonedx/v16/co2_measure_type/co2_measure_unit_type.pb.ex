defmodule SBoM.CycloneDX.V16.CO2MeasureType.CO2MeasureUnitType do
  @moduledoc "CycloneDX CO2MeasureType.CO2MeasureUnitType model."
  use Protobuf,
    enum: true,
    full_name: "cyclonedx.v1_6.CO2MeasureType.CO2MeasureUnitType",
    protoc_gen_elixir_version: "0.16.0",
    syntax: :proto3

  field(:CO2_MEASURE_UNIT_TYPE_UNSPECIFIED, 0)
  field(:CO2_MEASURE_UNIT_TYPE_TONNES_CO2_EQUIVALENT, 1)
end
