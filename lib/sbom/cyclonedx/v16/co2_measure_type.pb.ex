defmodule SBoM.CycloneDX.V16.CO2MeasureType do
  @moduledoc """
  A measure of carbon dioxide (CO2).
  """

  use Protobuf,
    full_name: "cyclonedx.v1_6.CO2MeasureType",
    protoc_gen_elixir_version: "0.16.0",
    syntax: :proto3

  field(:value, 1, type: :float)
  field(:unit, 2, type: SBoM.CycloneDX.V16.CO2MeasureType.CO2MeasureUnitType, enum: true)
end
