defmodule SBoM.CycloneDX.V17.EnergyMeasureType do
  @moduledoc """
  A measure of energy.
  """

  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field(:value, 1, type: :float)
  field(:unit, 2, type: SBoM.CycloneDX.V17.EnergyMeasureType.EnergyMeasureUnitType, enum: true)
end
