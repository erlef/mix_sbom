defmodule SBoM.CycloneDX.V16.ModelCard.ModelParameters do
  @moduledoc "CycloneDX ModelCard.ModelParameters model."
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  alias SBoM.CycloneDX.V16.ModelCard.ModelParameters.MachineLearningInputOutputParameters

  field(:approach, 1,
    proto3_optional: true,
    type: SBoM.CycloneDX.V16.ModelCard.ModelParameters.Approach
  )

  field(:task, 2, proto3_optional: true, type: :string)
  field(:architectureFamily, 3, proto3_optional: true, type: :string)
  field(:modelArchitecture, 4, proto3_optional: true, type: :string)
  field(:datasets, 5, repeated: true, type: SBoM.CycloneDX.V16.ModelCard.ModelParameters.Datasets)

  field(:inputs, 6,
    repeated: true,
    type: MachineLearningInputOutputParameters
  )

  field(:outputs, 7,
    repeated: true,
    type: MachineLearningInputOutputParameters
  )
end
