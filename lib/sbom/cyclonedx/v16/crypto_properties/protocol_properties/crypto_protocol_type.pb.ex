defmodule SBoM.CycloneDX.V16.CryptoProperties.ProtocolProperties.CryptoProtocolType do
  @moduledoc "CycloneDX CryptoProperties.ProtocolProperties.CryptoProtocolType model."
  use Protobuf,
    enum: true,
    full_name: "cyclonedx.v1_6.CryptoProperties.ProtocolProperties.CryptoProtocolType",
    protoc_gen_elixir_version: "0.16.0",
    syntax: :proto3

  field(:CRYPTO_PROTOCOL_TYPE_UNSPECIFIED, 0)
  field(:CRYPTO_PROTOCOL_TYPE_UNKNOWN, 1)
  field(:CRYPTO_PROTOCOL_TYPE_OTHER, 2)
  field(:CRYPTO_PROTOCOL_TYPE_TLS, 3)
  field(:CRYPTO_PROTOCOL_TYPE_SSH, 4)
  field(:CRYPTO_PROTOCOL_TYPE_IPSEC, 5)
  field(:CRYPTO_PROTOCOL_TYPE_IKE, 6)
  field(:CRYPTO_PROTOCOL_TYPE_SSTP, 7)
  field(:CRYPTO_PROTOCOL_TYPE_WPA, 8)
end
