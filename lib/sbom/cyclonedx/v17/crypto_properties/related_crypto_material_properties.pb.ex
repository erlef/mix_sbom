defmodule SBoM.CycloneDX.V17.CryptoProperties.RelatedCryptoMaterialProperties do
  @moduledoc """
  Related Cryptographic Material Properties
  """

  use Protobuf,
    full_name: "cyclonedx.v1_7.CryptoProperties.RelatedCryptoMaterialProperties",
    protoc_gen_elixir_version: "0.16.0",
    syntax: :proto3

  alias Google.Protobuf.Timestamp

  field(:type, 1,
    proto3_optional: true,
    type: SBoM.CycloneDX.V17.CryptoProperties.RelatedCryptoMaterialProperties.CryptoRelatedType,
    enum: true
  )

  field(:id, 2, proto3_optional: true, type: :string)

  field(:state, 3,
    proto3_optional: true,
    type: SBoM.CycloneDX.V17.CryptoProperties.RelatedCryptoMaterialProperties.CryptoRelatedState,
    enum: true
  )

  field(:algorithmRef, 4, proto3_optional: true, type: :string, deprecated: true)
  field(:creationDate, 5, proto3_optional: true, type: Timestamp)
  field(:activationDate, 6, proto3_optional: true, type: Timestamp)
  field(:updateDate, 7, proto3_optional: true, type: Timestamp)
  field(:expirationDate, 8, proto3_optional: true, type: Timestamp)
  field(:value, 9, proto3_optional: true, type: :string)
  field(:size, 10, proto3_optional: true, type: :int64)
  field(:format, 11, proto3_optional: true, type: :string)

  field(:securedBy, 12,
    proto3_optional: true,
    type: SBoM.CycloneDX.V17.CryptoProperties.RelatedCryptoMaterialProperties.CryptoRelatedSecuredBy
  )

  field(:fingerprint, 13, proto3_optional: true, type: SBoM.CycloneDX.V17.Hash)

  field(:relatedCryptographicAssets, 14,
    proto3_optional: true,
    type: SBoM.CycloneDX.V17.CryptoProperties.RelatedCryptographicAssets
  )
end
