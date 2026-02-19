defmodule SBoM.CycloneDX.V15.Hash do
  @moduledoc """
  Specifies the file hash of the component
  """

  use Protobuf,
    full_name: "cyclonedx.v1_5.Hash",
    protoc_gen_elixir_version: "0.16.0",
    syntax: :proto3

  field(:alg, 1, type: SBoM.CycloneDX.V15.HashAlg, enum: true)
  field(:value, 2, type: :string)
end
