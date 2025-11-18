defmodule SBoM.Cyclonedx.V13.Tool do
  @moduledoc false

  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field(:vendor, 1, proto3_optional: true, type: :string)
  field(:name, 2, proto3_optional: true, type: :string)
  field(:version, 3, proto3_optional: true, type: :string)
  field(:hashes, 4, repeated: true, type: SBoM.Cyclonedx.V13.Hash)
end
