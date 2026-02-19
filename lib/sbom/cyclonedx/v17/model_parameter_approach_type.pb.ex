defmodule SBoM.CycloneDX.V17.ModelParameterApproachType do
  @moduledoc "CycloneDX ModelParameterApproachType model."
  use Protobuf,
    enum: true,
    full_name: "cyclonedx.v1_7.ModelParameterApproachType",
    protoc_gen_elixir_version: "0.16.0",
    syntax: :proto3

  field(:MODEL_PARAMETER_APPROACH_TYPE_SUPERVISED, 0)
  field(:MODEL_PARAMETER_APPROACH_TYPE_UNSUPERVISED, 1)
  field(:MODEL_PARAMETER_APPROACH_TYPE_REINFORCED_LEARNING, 2)
  field(:MODEL_PARAMETER_APPROACH_TYPE_SEMI_SUPERVISED, 3)
  field(:MODEL_PARAMETER_APPROACH_TYPE_SELF_SUPERVISED, 4)
end
