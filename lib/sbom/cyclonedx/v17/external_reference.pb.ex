defmodule SBoM.Cyclonedx.V17.ExternalReference do
  @moduledoc false

  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field(:type, 1, type: SBoM.Cyclonedx.V17.ExternalReferenceType, enum: true)
  field(:url, 2, type: :string)
  field(:comment, 3, proto3_optional: true, type: :string)
  field(:hashes, 4, repeated: true, type: SBoM.Cyclonedx.V17.Hash)
  field(:properties, 5, repeated: true, type: SBoM.Cyclonedx.V17.Property)
end
