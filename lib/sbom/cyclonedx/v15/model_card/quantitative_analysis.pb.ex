defmodule SBoM.CycloneDX.V15.ModelCard.QuantitativeAnalysis do
  @moduledoc "CycloneDX ModelCard.QuantitativeAnalysis model."
  use Protobuf,
    full_name: "cyclonedx.v1_5.ModelCard.QuantitativeAnalysis",
    protoc_gen_elixir_version: "0.16.0",
    syntax: :proto3

  field(:performanceMetrics, 1,
    repeated: true,
    type: SBoM.CycloneDX.V15.ModelCard.QuantitativeAnalysis.PerformanceMetrics
  )

  field(:graphics, 2, proto3_optional: true, type: SBoM.CycloneDX.V15.GraphicsCollection)
end
