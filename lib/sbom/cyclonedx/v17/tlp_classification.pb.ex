defmodule SBoM.Cyclonedx.V17.TlpClassification do
  @moduledoc false

  use Protobuf, enum: true, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field(:TLP_CLASSIFICATION_CLEAR, 0)
  field(:TLP_CLASSIFICATION_GREEN, 1)
  field(:TLP_CLASSIFICATION_AMBER, 2)
  field(:TLP_CLASSIFICATION_AMBER_AND_STRICT, 3)
  field(:TLP_CLASSIFICATION_RED, 4)
end
