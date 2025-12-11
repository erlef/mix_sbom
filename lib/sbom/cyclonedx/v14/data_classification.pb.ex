defmodule SBoM.CycloneDX.V14.DataClassification do
  @moduledoc """
  Specifies the data classification.
  """

  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field(:flow, 1, type: SBoM.CycloneDX.V14.DataFlow, enum: true)
  field(:value, 2, type: :string)
end
