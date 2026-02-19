defmodule SBoM.CycloneDX.V16.CryptoProperties.ProtocolProperties.Ikev2TransformTypes do
  @moduledoc """
  IKEv2 Transform Types
  """

  use Protobuf,
    full_name: "cyclonedx.v1_6.CryptoProperties.ProtocolProperties.Ikev2TransformTypes",
    protoc_gen_elixir_version: "0.16.0",
    syntax: :proto3

  field(:encr, 1, repeated: true, type: :string)
  field(:prf, 2, repeated: true, type: :string)
  field(:integ, 3, repeated: true, type: :string)
  field(:ke, 4, repeated: true, type: :string)
  field(:esn, 5, proto3_optional: true, type: :bool)
  field(:auth, 6, repeated: true, type: :string)
end
