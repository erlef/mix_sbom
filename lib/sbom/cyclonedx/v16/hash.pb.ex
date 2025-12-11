defmodule SBoM.CycloneDX.V16.Hash do
  @moduledoc """
  Specifies the file hash of the component
  """

  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field(:alg, 1, type: SBoM.CycloneDX.V16.HashAlg, enum: true)
  field(:value, 2, type: :string)
end
