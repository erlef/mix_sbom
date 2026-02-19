defmodule SBoM.CycloneDX.V17.CryptoProperties.ProtocolProperties.Ikev2TransformTypesDetailed.Encr do
  @moduledoc """
  IKEv2 Encryption Algorithm (ENCR)
  """

  use Protobuf,
    full_name: "cyclonedx.v1_7.CryptoProperties.ProtocolProperties.Ikev2TransformTypesDetailed.Encr",
    protoc_gen_elixir_version: "0.16.0",
    syntax: :proto3

  field(:name, 1, proto3_optional: true, type: :string)
  field(:keyLength, 2, proto3_optional: true, type: :int32)
  field(:algorithm, 3, proto3_optional: true, type: :string)
end
