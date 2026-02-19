defmodule SBoM.CycloneDX.V17.Hash do
  @moduledoc """
  Specifies the file hash of the component
  """

  use Protobuf,
    full_name: "cyclonedx.v1_7.Hash",
    protoc_gen_elixir_version: "0.16.0",
    syntax: :proto3

  field(:alg, 1, type: SBoM.CycloneDX.V17.HashAlg, enum: true)
  field(:value, 2, type: :string)
end
