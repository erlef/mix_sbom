defmodule SBoM.CycloneDX.V15.ModelCard.ModelCardConsiderations do
  @moduledoc "CycloneDX ModelCard.ModelCardConsiderations model."
  use Protobuf,
    full_name: "cyclonedx.v1_5.ModelCard.ModelCardConsiderations",
    protoc_gen_elixir_version: "0.16.0",
    syntax: :proto3

  field(:users, 1, repeated: true, type: :string)
  field(:useCases, 2, repeated: true, type: :string)
  field(:technicalLimitations, 3, repeated: true, type: :string)
  field(:performanceTradeoffs, 4, repeated: true, type: :string)

  field(:ethicalConsiderations, 5,
    repeated: true,
    type: SBoM.CycloneDX.V15.ModelCard.ModelCardConsiderations.EthicalConsiderations
  )

  field(:fairnessAssessments, 6,
    repeated: true,
    type: SBoM.CycloneDX.V15.ModelCard.ModelCardConsiderations.FairnessAssessments
  )
end
