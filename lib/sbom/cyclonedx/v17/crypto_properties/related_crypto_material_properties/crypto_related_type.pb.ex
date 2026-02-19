defmodule SBoM.CycloneDX.V17.CryptoProperties.RelatedCryptoMaterialProperties.CryptoRelatedType do
  @moduledoc """
  relatedCryptoMaterialType
  """

  use Protobuf,
    enum: true,
    full_name: "cyclonedx.v1_7.CryptoProperties.RelatedCryptoMaterialProperties.CryptoRelatedType",
    protoc_gen_elixir_version: "0.16.0",
    syntax: :proto3

  field(:CRYPTO_RELATED_TYPE_UNSPECIFIED, 0)
  field(:CRYPTO_RELATED_TYPE_UNKNOWN, 1)
  field(:CRYPTO_RELATED_TYPE_OTHER, 2)
  field(:CRYPTO_RELATED_TYPE_PRIVATE_KEY, 3)
  field(:CRYPTO_RELATED_TYPE_PUBLIC_KEY, 4)
  field(:CRYPTO_RELATED_TYPE_SECRET_KEY, 5)
  field(:CRYPTO_RELATED_TYPE_KEY, 6)
  field(:CRYPTO_RELATED_TYPE_CIPHERTEXT, 7)
  field(:CRYPTO_RELATED_TYPE_SIGNATURE, 8)
  field(:CRYPTO_RELATED_TYPE_DIGEST, 9)
  field(:CRYPTO_RELATED_TYPE_INITIALIZATION_VECTOR, 10)
  field(:CRYPTO_RELATED_TYPE_NONCE, 11)
  field(:CRYPTO_RELATED_TYPE_SEED, 12)
  field(:CRYPTO_RELATED_TYPE_SALT, 13)
  field(:CRYPTO_RELATED_TYPE_SHARED_SECRET, 14)
  field(:CRYPTO_RELATED_TYPE_TAG, 15)
  field(:CRYPTO_RELATED_TYPE_ADDITIONAL_DATA, 16)
  field(:CRYPTO_RELATED_TYPE_PASSWORD, 17)
  field(:CRYPTO_RELATED_TYPE_CREDENTIAL, 18)
  field(:CRYPTO_RELATED_TYPE_TOKEN, 19)
end
