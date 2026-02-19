defmodule SBoM.CycloneDX.V15.ModelCard.ModelCardConsiderations.FairnessAssessments do
  @moduledoc "CycloneDX ModelCard.ModelCardConsiderations.FairnessAssessments model."
  use Protobuf,
    full_name: "cyclonedx.v1_5.ModelCard.ModelCardConsiderations.FairnessAssessments",
    protoc_gen_elixir_version: "0.16.0",
    syntax: :proto3

  field(:groupAtRisk, 1, proto3_optional: true, type: :string)
  field(:benefits, 2, proto3_optional: true, type: :string)
  field(:harms, 3, proto3_optional: true, type: :string)
  field(:mitigationStrategy, 4, proto3_optional: true, type: :string)
end
