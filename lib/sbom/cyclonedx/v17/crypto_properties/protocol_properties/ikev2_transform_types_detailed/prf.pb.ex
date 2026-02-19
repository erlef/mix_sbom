defmodule SBoM.CycloneDX.V17.CryptoProperties.ProtocolProperties.Ikev2TransformTypesDetailed.Prf do
  @moduledoc """
  IKEv2 Pseudorandom Function (PRF)
  """

  use Protobuf,
    full_name: "cyclonedx.v1_7.CryptoProperties.ProtocolProperties.Ikev2TransformTypesDetailed.Prf",
    protoc_gen_elixir_version: "0.16.0",
    syntax: :proto3

  field(:name, 1, proto3_optional: true, type: :string)
  field(:algorithm, 2, proto3_optional: true, type: :string)
end
