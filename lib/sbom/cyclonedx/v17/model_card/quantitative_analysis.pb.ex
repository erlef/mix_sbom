defmodule SBoM.CycloneDX.V17.ModelCard.QuantitativeAnalysis do
  @moduledoc "CycloneDX ModelCard.QuantitativeAnalysis model."
  use Protobuf,
    full_name: "cyclonedx.v1_7.ModelCard.QuantitativeAnalysis",
    protoc_gen_elixir_version: "0.16.0",
    syntax: :proto3

  field(:performanceMetrics, 1,
    repeated: true,
    type: SBoM.CycloneDX.V17.ModelCard.QuantitativeAnalysis.PerformanceMetrics
  )

  field(:graphics, 2, proto3_optional: true, type: SBoM.CycloneDX.V17.GraphicsCollection)
end
