defmodule SBoM.CycloneDX.V15.ModelCard.QuantitativeAnalysis.PerformanceMetrics.ConfidenceInterval do
  @moduledoc "CycloneDX ModelCard.QuantitativeAnalysis.PerformanceMetrics.ConfidenceInterval model."
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field(:lowerBound, 1, proto3_optional: true, type: :string)
  field(:upperBound, 2, proto3_optional: true, type: :string)
end
