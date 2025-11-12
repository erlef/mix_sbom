defmodule SBoM.Cyclonedx.V17.ModelCard.ModelCardConsiderations do
  @moduledoc false

  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field(:users, 1, repeated: true, type: :string)
  field(:useCases, 2, repeated: true, type: :string)
  field(:technicalLimitations, 3, repeated: true, type: :string)
  field(:performanceTradeoffs, 4, repeated: true, type: :string)

  field(:ethicalConsiderations, 5,
    repeated: true,
    type: SBoM.Cyclonedx.V17.ModelCard.ModelCardConsiderations.EthicalConsiderations
  )

  field(:fairnessAssessments, 6,
    repeated: true,
    type: SBoM.Cyclonedx.V17.ModelCard.ModelCardConsiderations.FairnessAssessments
  )

  field(:environmentalConsiderations, 7,
    proto3_optional: true,
    type: SBoM.Cyclonedx.V17.ModelCard.ModelCardConsiderations.EnvironmentalConsiderations
  )
end
