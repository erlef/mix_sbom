defmodule SBoM.CycloneDX.V17.CryptoProperties.ProtocolProperties do
  @moduledoc """
  Protocol Properties
  """

  use Protobuf,
    full_name: "cyclonedx.v1_7.CryptoProperties.ProtocolProperties",
    protoc_gen_elixir_version: "0.16.0",
    syntax: :proto3

  field(:type, 1,
    proto3_optional: true,
    type: SBoM.CycloneDX.V17.CryptoProperties.ProtocolProperties.CryptoProtocolType,
    enum: true
  )

  field(:version, 2, proto3_optional: true, type: :string)

  field(:cipherSuites, 3,
    repeated: true,
    type: SBoM.CycloneDX.V17.CryptoProperties.ProtocolProperties.CryptoProtocolCipherSuite
  )

  field(:ikev2TransformTypes, 4,
    proto3_optional: true,
    type: SBoM.CycloneDX.V17.CryptoProperties.ProtocolProperties.Ikev2TransformTypes,
    deprecated: true
  )

  field(:ikev2TransformTypesDetailed, 7,
    proto3_optional: true,
    type: SBoM.CycloneDX.V17.CryptoProperties.ProtocolProperties.Ikev2TransformTypesDetailed
  )

  field(:cryptoRef, 5, repeated: true, type: :string)

  field(:relatedCryptographicAssets, 6,
    proto3_optional: true,
    type: SBoM.CycloneDX.V17.CryptoProperties.RelatedCryptographicAssets
  )
end
