defmodule SBoM.CycloneDX.V16.ComponentDataType do
  @moduledoc "CycloneDX ComponentDataType model."
  use Protobuf,
    enum: true,
    full_name: "cyclonedx.v1_6.ComponentDataType",
    protoc_gen_elixir_version: "0.16.0",
    syntax: :proto3

  field(:COMPONENT_DATA_TYPE_SOURCE_CODE, 0)
  field(:COMPONENT_DATA_TYPE_CONFIGURATION, 1)
  field(:COMPONENT_DATA_TYPE_DATASET, 2)
  field(:COMPONENT_DATA_TYPE_DEFINITION, 3)
  field(:COMPONENT_DATA_TYPE_OTHER, 4)
end
