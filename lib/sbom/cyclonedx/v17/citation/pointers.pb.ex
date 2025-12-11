defmodule SBoM.CycloneDX.V17.Citation.Pointers do
  @moduledoc "CycloneDX Citation.Pointers model."
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field(:pointer, 1, repeated: true, type: :string)
end
