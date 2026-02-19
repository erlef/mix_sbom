defmodule SBoM.CycloneDX.V15.ModelCard.QuantitativeAnalysis.PerformanceMetrics do
  @moduledoc "CycloneDX ModelCard.QuantitativeAnalysis.PerformanceMetrics model."
  use Protobuf,
    full_name: "cyclonedx.v1_5.ModelCard.QuantitativeAnalysis.PerformanceMetrics",
    protoc_gen_elixir_version: "0.16.0",
    syntax: :proto3

  field(:type, 1, proto3_optional: true, type: :string)
  field(:value, 2, proto3_optional: true, type: :string)
  field(:slice, 3, proto3_optional: true, type: :string)

  field(:confidenceInterval, 4,
    proto3_optional: true,
    type: SBoM.CycloneDX.V15.ModelCard.QuantitativeAnalysis.PerformanceMetrics.ConfidenceInterval
  )
end
