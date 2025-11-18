defmodule SBoM.Cyclonedx.V16.ModelCard.QuantitativeAnalysis.PerformanceMetrics.ConfidenceInterval do
  @moduledoc false

  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field(:lowerBound, 1, proto3_optional: true, type: :string)
  field(:upperBound, 2, proto3_optional: true, type: :string)
end
