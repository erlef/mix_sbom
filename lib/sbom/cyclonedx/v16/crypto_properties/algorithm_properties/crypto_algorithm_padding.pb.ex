defmodule SBoM.CycloneDX.V16.CryptoProperties.AlgorithmProperties.CryptoAlgorithmPadding do
  @moduledoc """
  Padding
  """

  use Protobuf,
    enum: true,
    full_name: "cyclonedx.v1_6.CryptoProperties.AlgorithmProperties.CryptoAlgorithmPadding",
    protoc_gen_elixir_version: "0.16.0",
    syntax: :proto3

  field(:CRYPTO_ALGORITHM_PADDING_UNSPECIFIED, 0)
  field(:CRYPTO_ALGORITHM_PADDING_UNKNOWN, 1)
  field(:CRYPTO_ALGORITHM_PADDING_OTHER, 2)
  field(:CRYPTO_ALGORITHM_PADDING_PKCS5, 3)
  field(:CRYPTO_ALGORITHM_PADDING_PKCS7, 4)
  field(:CRYPTO_ALGORITHM_PADDING_PKCS1V15, 5)
  field(:CRYPTO_ALGORITHM_PADDING_OAEP, 6)
  field(:CRYPTO_ALGORITHM_PADDING_RAW, 7)
end
