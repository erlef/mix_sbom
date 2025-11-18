defmodule SBoM.Cyclonedx.V14.Classification do
  @moduledoc false

  use Protobuf, enum: true, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field(:CLASSIFICATION_NULL, 0)
  field(:CLASSIFICATION_APPLICATION, 1)
  field(:CLASSIFICATION_FRAMEWORK, 2)
  field(:CLASSIFICATION_LIBRARY, 3)
  field(:CLASSIFICATION_OPERATING_SYSTEM, 4)
  field(:CLASSIFICATION_DEVICE, 5)
  field(:CLASSIFICATION_FILE, 6)
  field(:CLASSIFICATION_CONTAINER, 7)
  field(:CLASSIFICATION_FIRMWARE, 8)
end
