defmodule SBoM.Cyclonedx.V15.ComponentDataType do
  @moduledoc false

  use Protobuf, enum: true, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field(:COMPONENT_DATA_TYPE_SOURCE_CODE, 0)
  field(:COMPONENT_DATA_TYPE_CONFIGURATION, 1)
  field(:COMPONENT_DATA_TYPE_DATASET, 2)
  field(:COMPONENT_DATA_TYPE_DEFINITION, 3)
  field(:COMPONENT_DATA_TYPE_OTHER, 4)
end
