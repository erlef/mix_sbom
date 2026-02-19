defmodule SBoM.CycloneDX.V17.CryptoProperties.AlgorithmProperties.CryptoExecutionEnvironment do
  @moduledoc """
  Execution Environment
  """

  use Protobuf,
    enum: true,
    full_name: "cyclonedx.v1_7.CryptoProperties.AlgorithmProperties.CryptoExecutionEnvironment",
    protoc_gen_elixir_version: "0.16.0",
    syntax: :proto3

  field(:CRYPTO_EXECUTION_ENVIRONMENT_UNSPECIFIED, 0)
  field(:CRYPTO_EXECUTION_ENVIRONMENT_UNKNOWN, 1)
  field(:CRYPTO_EXECUTION_ENVIRONMENT_OTHER, 2)
  field(:CRYPTO_EXECUTION_ENVIRONMENT_SOFTWARE_PLAIN_RAM, 3)
  field(:CRYPTO_EXECUTION_ENVIRONMENT_SOFTWARE_ENCRYPTED_RAM, 4)
  field(:CRYPTO_EXECUTION_ENVIRONMENT_SOFTWARE_TEE, 5)
  field(:CRYPTO_EXECUTION_ENVIRONMENT_HARDWARE, 6)
end
