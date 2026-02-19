defmodule SBoM.CycloneDX.V17.ModelCard.ModelParameters.Datasets do
  @moduledoc "CycloneDX ModelCard.ModelParameters.Datasets model."
  use Protobuf,
    full_name: "cyclonedx.v1_7.ModelCard.ModelParameters.Datasets",
    protoc_gen_elixir_version: "0.16.0",
    syntax: :proto3

  oneof(:choice, 0)

  field(:dataset, 1, type: SBoM.CycloneDX.V17.ComponentData, oneof: 0)
  field(:ref, 2, type: :string, oneof: 0)
end
