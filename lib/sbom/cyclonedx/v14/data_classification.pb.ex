defmodule SBoM.Cyclonedx.V14.DataClassification do
  @moduledoc false

  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field(:flow, 1, type: SBoM.Cyclonedx.V14.DataFlow, enum: true)
  field(:value, 2, type: :string)
end
