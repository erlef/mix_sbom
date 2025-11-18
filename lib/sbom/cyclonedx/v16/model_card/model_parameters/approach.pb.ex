defmodule SBoM.Cyclonedx.V16.ModelCard.ModelParameters.Approach do
  @moduledoc false

  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field(:type, 1,
    proto3_optional: true,
    type: SBoM.Cyclonedx.V16.ModelParameterApproachType,
    enum: true
  )
end
