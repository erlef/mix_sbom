defmodule SBoM.CycloneDX.V15.ModelCard.ModelParameters.Approach do
  @moduledoc "CycloneDX ModelCard.ModelParameters.Approach model."
  use Protobuf,
    full_name: "cyclonedx.v1_5.ModelCard.ModelParameters.Approach",
    protoc_gen_elixir_version: "0.16.0",
    syntax: :proto3

  field(:type, 1,
    proto3_optional: true,
    type: SBoM.CycloneDX.V15.ModelParameterApproachType,
    enum: true
  )
end
