defmodule SBoM.Cyclonedx.V13.Hash do
  @moduledoc false

  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field(:alg, 1, type: SBoM.Cyclonedx.V13.HashAlg, enum: true)
  field(:value, 2, type: :string)
end
