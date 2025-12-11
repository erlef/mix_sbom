defmodule SBoM.CycloneDX.V17.CryptoProperties.ProtocolProperties.CryptoProtocolType do
  @moduledoc "CycloneDX CryptoProperties.ProtocolProperties.CryptoProtocolType model."
  use Protobuf, enum: true, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field(:CRYPTO_PROTOCOL_TYPE_UNSPECIFIED, 0)
  field(:CRYPTO_PROTOCOL_TYPE_UNKNOWN, 1)
  field(:CRYPTO_PROTOCOL_TYPE_OTHER, 2)
  field(:CRYPTO_PROTOCOL_TYPE_TLS, 3)
  field(:CRYPTO_PROTOCOL_TYPE_SSH, 4)
  field(:CRYPTO_PROTOCOL_TYPE_IPSEC, 5)
  field(:CRYPTO_PROTOCOL_TYPE_IKE, 6)
  field(:CRYPTO_PROTOCOL_TYPE_SSTP, 7)
  field(:CRYPTO_PROTOCOL_TYPE_WPA, 8)
  field(:CRYPTO_PROTOCOL_TYPE_DTLS, 9)
  field(:CRYPTO_PROTOCOL_TYPE_QUIC, 10)
  field(:CRYPTO_PROTOCOL_TYPE_EAP_AKA, 11)
  field(:CRYPTO_PROTOCOL_TYPE_EAP_AKA_PRIME, 12)
  field(:CRYPTO_PROTOCOL_TYPE_PRINS, 13)
  field(:CRYPTO_PROTOCOL_TYPE_5G_AKA, 14)
end
