defmodule SBoM.Cyclonedx.V16.CryptoProperties.AlgorithmProperties do
  @moduledoc false

  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field(:primitive, 1,
    proto3_optional: true,
    type: SBoM.Cyclonedx.V16.CryptoProperties.AlgorithmProperties.CryptoPrimitive,
    enum: true
  )

  field(:parameterSetIdentifier, 2, proto3_optional: true, type: :string)
  field(:curve, 3, proto3_optional: true, type: :string)

  field(:executionEnvironment, 4,
    proto3_optional: true,
    type: SBoM.Cyclonedx.V16.CryptoProperties.AlgorithmProperties.CryptoExecutionEnvironment,
    enum: true
  )

  field(:implementationPlatform, 5,
    proto3_optional: true,
    type: SBoM.Cyclonedx.V16.CryptoProperties.AlgorithmProperties.CryptoImplementationPlatform,
    enum: true
  )

  field(:certificationLevel, 6, repeated: true, type: :string)

  field(:mode, 7,
    proto3_optional: true,
    type: SBoM.Cyclonedx.V16.CryptoProperties.AlgorithmProperties.CryptoAlgorithmMode,
    enum: true
  )

  field(:padding, 8,
    proto3_optional: true,
    type: SBoM.Cyclonedx.V16.CryptoProperties.AlgorithmProperties.CryptoAlgorithmPadding,
    enum: true
  )

  field(:cryptoFunctions, 9,
    repeated: true,
    type: SBoM.Cyclonedx.V16.CryptoProperties.AlgorithmProperties.CryptoAlgorithmFunction,
    enum: true
  )

  field(:classicalSecurityLevel, 10, proto3_optional: true, type: :int32)
  field(:nistQuantumSecurityLevel, 11, proto3_optional: true, type: :int32)
end
