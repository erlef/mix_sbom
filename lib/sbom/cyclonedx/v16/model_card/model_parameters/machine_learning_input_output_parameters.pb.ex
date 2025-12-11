defmodule SBoM.CycloneDX.V16.ModelCard.ModelParameters.MachineLearningInputOutputParameters do
  @moduledoc "CycloneDX ModelCard.ModelParameters.MachineLearningInputOutputParameters model."
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field(:format, 1, proto3_optional: true, type: :string)
end
