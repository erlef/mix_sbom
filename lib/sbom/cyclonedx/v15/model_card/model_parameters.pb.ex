defmodule SBoM.Cyclonedx.V15.ModelCard.ModelParameters do
  @moduledoc false

  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  alias SBoM.Cyclonedx.V15.ModelCard.ModelParameters.MachineLearningInputOutputParameters

  field(:approach, 1,
    proto3_optional: true,
    type: SBoM.Cyclonedx.V15.ModelCard.ModelParameters.Approach
  )

  field(:task, 2, proto3_optional: true, type: :string)
  field(:architectureFamily, 3, proto3_optional: true, type: :string)
  field(:modelArchitecture, 4, proto3_optional: true, type: :string)
  field(:datasets, 5, repeated: true, type: SBoM.Cyclonedx.V15.ModelCard.ModelParameters.Datasets)

  field(:inputs, 6,
    repeated: true,
    type: MachineLearningInputOutputParameters
  )

  field(:outputs, 7,
    repeated: true,
    type: MachineLearningInputOutputParameters
  )
end
