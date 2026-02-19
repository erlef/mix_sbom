defmodule SBoM.CycloneDX.V16.EnergyMeasureType do
  @moduledoc """
  A measure of energy.
  """

  use Protobuf,
    full_name: "cyclonedx.v1_6.EnergyMeasureType",
    protoc_gen_elixir_version: "0.16.0",
    syntax: :proto3

  field(:value, 1, type: :float)
  field(:unit, 2, type: SBoM.CycloneDX.V16.EnergyMeasureType.EnergyMeasureUnitType, enum: true)
end
