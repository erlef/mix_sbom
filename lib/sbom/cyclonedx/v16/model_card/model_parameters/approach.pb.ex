defmodule SBoM.CycloneDX.V16.ModelCard.ModelParameters.Approach do
  @moduledoc "CycloneDX ModelCard.ModelParameters.Approach model."
  use Protobuf,
    full_name: "cyclonedx.v1_6.ModelCard.ModelParameters.Approach",
    protoc_gen_elixir_version: "0.16.0",
    syntax: :proto3

  field(:type, 1,
    proto3_optional: true,
    type: SBoM.CycloneDX.V16.ModelParameterApproachType,
    enum: true
  )
end
