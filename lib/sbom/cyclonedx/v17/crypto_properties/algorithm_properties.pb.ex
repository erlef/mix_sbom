defmodule SBoM.CycloneDX.V17.CryptoProperties.AlgorithmProperties do
  @moduledoc """
  Algorithm Propertie
  """

  use Protobuf,
    full_name: "cyclonedx.v1_7.CryptoProperties.AlgorithmProperties",
    protoc_gen_elixir_version: "0.16.0",
    syntax: :proto3

  field(:primitive, 1,
    proto3_optional: true,
    type: SBoM.CycloneDX.V17.CryptoProperties.AlgorithmProperties.CryptoPrimitive,
    enum: true
  )

  field(:algorithmFamily, 12, proto3_optional: true, type: :string)
  field(:parameterSetIdentifier, 2, proto3_optional: true, type: :string)
  field(:curve, 3, proto3_optional: true, type: :string, deprecated: true)
  field(:ellipticCurve, 13, proto3_optional: true, type: :string)

  field(:executionEnvironment, 4,
    proto3_optional: true,
    type: SBoM.CycloneDX.V17.CryptoProperties.AlgorithmProperties.CryptoExecutionEnvironment,
    enum: true
  )

  field(:implementationPlatform, 5,
    proto3_optional: true,
    type: SBoM.CycloneDX.V17.CryptoProperties.AlgorithmProperties.CryptoImplementationPlatform,
    enum: true
  )

  field(:certificationLevel, 6, repeated: true, type: :string)

  field(:mode, 7,
    proto3_optional: true,
    type: SBoM.CycloneDX.V17.CryptoProperties.AlgorithmProperties.CryptoAlgorithmMode,
    enum: true
  )

  field(:padding, 8,
    proto3_optional: true,
    type: SBoM.CycloneDX.V17.CryptoProperties.AlgorithmProperties.CryptoAlgorithmPadding,
    enum: true
  )

  field(:cryptoFunctions, 9,
    repeated: true,
    type: SBoM.CycloneDX.V17.CryptoProperties.AlgorithmProperties.CryptoAlgorithmFunction,
    enum: true
  )

  field(:classicalSecurityLevel, 10, proto3_optional: true, type: :int32)
  field(:nistQuantumSecurityLevel, 11, proto3_optional: true, type: :int32)
end
