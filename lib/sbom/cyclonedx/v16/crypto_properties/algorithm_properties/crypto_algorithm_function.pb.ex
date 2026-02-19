defmodule SBoM.CycloneDX.V16.CryptoProperties.AlgorithmProperties.CryptoAlgorithmFunction do
  @moduledoc """
  Cryptographic functions
  """

  use Protobuf,
    enum: true,
    full_name: "cyclonedx.v1_6.CryptoProperties.AlgorithmProperties.CryptoAlgorithmFunction",
    protoc_gen_elixir_version: "0.16.0",
    syntax: :proto3

  field(:CRYPTO_ALGORITHM_FUNCTION_UNSPECIFIED, 0)
  field(:CRYPTO_ALGORITHM_FUNCTION_UNKNOWN, 1)
  field(:CRYPTO_ALGORITHM_FUNCTION_OTHER, 2)
  field(:CRYPTO_ALGORITHM_FUNCTION_GENERATE, 3)
  field(:CRYPTO_ALGORITHM_FUNCTION_KEYGEN, 4)
  field(:CRYPTO_ALGORITHM_FUNCTION_ENCRYPT, 5)
  field(:CRYPTO_ALGORITHM_FUNCTION_DECRYPT, 6)
  field(:CRYPTO_ALGORITHM_FUNCTION_DIGEST, 7)
  field(:CRYPTO_ALGORITHM_FUNCTION_TAG, 8)
  field(:CRYPTO_ALGORITHM_FUNCTION_KEYDERIVE, 9)
  field(:CRYPTO_ALGORITHM_FUNCTION_SIGN, 10)
  field(:CRYPTO_ALGORITHM_FUNCTION_VERIFY, 11)
  field(:CRYPTO_ALGORITHM_FUNCTION_ENCAPSULATE, 12)
  field(:CRYPTO_ALGORITHM_FUNCTION_DECAPSULATE, 13)
end
