defmodule SBoM.CycloneDX.V17.ModelCard.QuantitativeAnalysis.PerformanceMetrics do
  @moduledoc "CycloneDX ModelCard.QuantitativeAnalysis.PerformanceMetrics model."
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field(:type, 1, proto3_optional: true, type: :string)
  field(:value, 2, proto3_optional: true, type: :string)
  field(:slice, 3, proto3_optional: true, type: :string)

  field(:confidenceInterval, 4,
    proto3_optional: true,
    type: SBoM.CycloneDX.V17.ModelCard.QuantitativeAnalysis.PerformanceMetrics.ConfidenceInterval
  )
end
