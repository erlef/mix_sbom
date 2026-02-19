defmodule SBoM.CycloneDX.V16.CryptoProperties.AlgorithmProperties.CryptoAlgorithmMode do
  @moduledoc """
  Mode
  """

  use Protobuf,
    enum: true,
    full_name: "cyclonedx.v1_6.CryptoProperties.AlgorithmProperties.CryptoAlgorithmMode",
    protoc_gen_elixir_version: "0.16.0",
    syntax: :proto3

  field(:CRYPTO_ALGORITHM_MODE_UNSPECIFIED, 0)
  field(:CRYPTO_ALGORITHM_MODE_UNKNOWN, 1)
  field(:CRYPTO_ALGORITHM_MODE_OTHER, 2)
  field(:CRYPTO_ALGORITHM_MODE_CBC, 3)
  field(:CRYPTO_ALGORITHM_MODE_ECB, 4)
  field(:CRYPTO_ALGORITHM_MODE_CCM, 5)
  field(:CRYPTO_ALGORITHM_MODE_GCM, 6)
  field(:CRYPTO_ALGORITHM_MODE_CFB, 7)
  field(:CRYPTO_ALGORITHM_MODE_OFB, 8)
  field(:CRYPTO_ALGORITHM_MODE_CTR, 9)
end
