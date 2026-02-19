defmodule SBoM.CycloneDX.V16.CryptoProperties do
  @moduledoc """
  "Cryptographic Properties
  """

  use Protobuf,
    full_name: "cyclonedx.v1_6.CryptoProperties",
    protoc_gen_elixir_version: "0.16.0",
    syntax: :proto3

  field(:assetType, 1, type: SBoM.CycloneDX.V16.CryptoProperties.CryptoAssetType, enum: true)

  field(:algorithmProperties, 2,
    proto3_optional: true,
    type: SBoM.CycloneDX.V16.CryptoProperties.AlgorithmProperties
  )

  field(:certificateProperties, 3,
    proto3_optional: true,
    type: SBoM.CycloneDX.V16.CryptoProperties.CertificateProperties
  )

  field(:relatedCryptoMaterialProperties, 4,
    proto3_optional: true,
    type: SBoM.CycloneDX.V16.CryptoProperties.RelatedCryptoMaterialProperties
  )

  field(:protocolProperties, 5,
    proto3_optional: true,
    type: SBoM.CycloneDX.V16.CryptoProperties.ProtocolProperties
  )

  field(:oid, 6, proto3_optional: true, type: :string)
end
