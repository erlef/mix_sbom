defmodule SBoM.Cyclonedx.V15.ModelCard do
  @moduledoc false

  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field(:bom_ref, 1, proto3_optional: true, type: :string, json_name: "bomRef")

  field(:modelParameters, 2,
    proto3_optional: true,
    type: SBoM.Cyclonedx.V15.ModelCard.ModelParameters
  )

  field(:quantitativeAnalysis, 3,
    proto3_optional: true,
    type: SBoM.Cyclonedx.V15.ModelCard.QuantitativeAnalysis
  )

  field(:considerations, 4,
    proto3_optional: true,
    type: SBoM.Cyclonedx.V15.ModelCard.ModelCardConsiderations
  )
end
