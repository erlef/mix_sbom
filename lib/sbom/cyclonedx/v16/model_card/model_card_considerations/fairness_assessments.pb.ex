defmodule SBoM.Cyclonedx.V16.ModelCard.ModelCardConsiderations.FairnessAssessments do
  @moduledoc false

  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field(:groupAtRisk, 1, proto3_optional: true, type: :string)
  field(:benefits, 2, proto3_optional: true, type: :string)
  field(:harms, 3, proto3_optional: true, type: :string)
  field(:mitigationStrategy, 4, proto3_optional: true, type: :string)
end
