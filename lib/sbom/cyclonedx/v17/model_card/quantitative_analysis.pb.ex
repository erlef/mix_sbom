defmodule SBoM.Cyclonedx.V17.ModelCard.QuantitativeAnalysis do
  @moduledoc false

  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field(:performanceMetrics, 1,
    repeated: true,
    type: SBoM.Cyclonedx.V17.ModelCard.QuantitativeAnalysis.PerformanceMetrics
  )

  field(:graphics, 2, proto3_optional: true, type: SBoM.Cyclonedx.V17.GraphicsCollection)
end
