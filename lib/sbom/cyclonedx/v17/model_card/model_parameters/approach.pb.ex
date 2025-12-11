defmodule SBoM.CycloneDX.V17.ModelCard.ModelParameters.Approach do
  @moduledoc "CycloneDX ModelCard.ModelParameters.Approach model."
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field(:type, 1,
    proto3_optional: true,
    type: SBoM.CycloneDX.V17.ModelParameterApproachType,
    enum: true
  )
end
