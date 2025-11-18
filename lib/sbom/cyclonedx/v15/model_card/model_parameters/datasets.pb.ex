defmodule SBoM.Cyclonedx.V15.ModelCard.ModelParameters.Datasets do
  @moduledoc false

  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  oneof(:choice, 0)

  field(:dataset, 1, type: SBoM.Cyclonedx.V15.ComponentData, oneof: 0)
  field(:ref, 2, type: :string, oneof: 0)
end
