defmodule SBoM.CycloneDX.V17.ModelCard.ModelParameters.MachineLearningInputOutputParameters do
  @moduledoc "CycloneDX ModelCard.ModelParameters.MachineLearningInputOutputParameters model."
  use Protobuf,
    full_name: "cyclonedx.v1_7.ModelCard.ModelParameters.MachineLearningInputOutputParameters",
    protoc_gen_elixir_version: "0.16.0",
    syntax: :proto3

  field(:format, 1, proto3_optional: true, type: :string)
end
