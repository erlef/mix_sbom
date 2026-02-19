defmodule SBoM.CycloneDX.V16.CryptoProperties.AlgorithmProperties.CryptoPrimitive do
  @moduledoc """
  Primitive
  """

  use Protobuf,
    enum: true,
    full_name: "cyclonedx.v1_6.CryptoProperties.AlgorithmProperties.CryptoPrimitive",
    protoc_gen_elixir_version: "0.16.0",
    syntax: :proto3

  field(:CRYPTO_PRIMITIVE_UNSPECIFIED, 0)
  field(:CRYPTO_PRIMITIVE_UNKNOWN, 1)
  field(:CRYPTO_PRIMITIVE_OTHER, 2)
  field(:CRYPTO_PRIMITIVE_DRBG, 3)
  field(:CRYPTO_PRIMITIVE_MAC, 4)
  field(:CRYPTO_PRIMITIVE_BLOCK_CIPHER, 5)
  field(:CRYPTO_PRIMITIVE_STREAM_CIPHER, 6)
  field(:CRYPTO_PRIMITIVE_SIGNATURE, 7)
  field(:CRYPTO_PRIMITIVE_HASH, 8)
  field(:CRYPTO_PRIMITIVE_PKE, 9)
  field(:CRYPTO_PRIMITIVE_XOF, 10)
  field(:CRYPTO_PRIMITIVE_KDF, 11)
  field(:CRYPTO_PRIMITIVE_KEY_AGREE, 12)
  field(:CRYPTO_PRIMITIVE_KEM, 13)
  field(:CRYPTO_PRIMITIVE_AE, 14)
  field(:CRYPTO_PRIMITIVE_COMBINER, 15)
end
