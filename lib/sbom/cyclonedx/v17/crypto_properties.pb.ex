defmodule SBoM.Cyclonedx.V17.CryptoProperties do
  @moduledoc false

  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field(:assetType, 1, type: SBoM.Cyclonedx.V17.CryptoProperties.CryptoAssetType, enum: true)

  field(:algorithmProperties, 2,
    proto3_optional: true,
    type: SBoM.Cyclonedx.V17.CryptoProperties.AlgorithmProperties
  )

  field(:certificateProperties, 3,
    proto3_optional: true,
    type: SBoM.Cyclonedx.V17.CryptoProperties.CertificateProperties
  )

  field(:relatedCryptoMaterialProperties, 4,
    proto3_optional: true,
    type: SBoM.Cyclonedx.V17.CryptoProperties.RelatedCryptoMaterialProperties
  )

  field(:protocolProperties, 5,
    proto3_optional: true,
    type: SBoM.Cyclonedx.V17.CryptoProperties.ProtocolProperties
  )

  field(:oid, 6, proto3_optional: true, type: :string)
end
