defmodule SBoM.Cyclonedx.V15.ModelParameterApproachType do
  @moduledoc false

  use Protobuf, enum: true, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field(:MODEL_PARAMETER_APPROACH_TYPE_SUPERVISED, 0)
  field(:MODEL_PARAMETER_APPROACH_TYPE_UNSUPERVISED, 1)
  field(:MODEL_PARAMETER_APPROACH_TYPE_REINFORCED_LEARNING, 2)
  field(:MODEL_PARAMETER_APPROACH_TYPE_SEMI_SUPERVISED, 3)
  field(:MODEL_PARAMETER_APPROACH_TYPE_SELF_SUPERVISED, 4)
end
