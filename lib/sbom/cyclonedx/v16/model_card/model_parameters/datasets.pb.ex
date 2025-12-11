defmodule SBoM.CycloneDX.V16.ModelCard.ModelParameters.Datasets do
  @moduledoc "CycloneDX ModelCard.ModelParameters.Datasets model."
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  oneof(:choice, 0)

  field(:dataset, 1, type: SBoM.CycloneDX.V16.ComponentData, oneof: 0)
  field(:ref, 2, type: :string, oneof: 0)
end
