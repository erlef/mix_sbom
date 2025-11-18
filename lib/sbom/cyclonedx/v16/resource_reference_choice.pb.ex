defmodule SBoM.Cyclonedx.V16.ResourceReferenceChoice do
  @moduledoc false

  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  oneof(:choice, 0)

  field(:ref, 1, type: :string, oneof: 0)
  field(:externalReference, 2, type: SBoM.Cyclonedx.V16.ExternalReference, oneof: 0)
end
