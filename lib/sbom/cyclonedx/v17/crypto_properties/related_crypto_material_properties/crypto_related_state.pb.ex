defmodule SBoM.Cyclonedx.V17.CryptoProperties.RelatedCryptoMaterialProperties.CryptoRelatedState do
  @moduledoc false

  use Protobuf, enum: true, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field(:CRYPTO_RELATED_STATE_UNSPECIFIED, 0)
  field(:CRYPTO_RELATED_STATE_PRE_ACTIVATION, 1)
  field(:CRYPTO_RELATED_STATE_ACTIVE, 2)
  field(:CRYPTO_RELATED_STATE_SUSPENDED, 3)
  field(:CRYPTO_RELATED_STATE_DEACTIVATED, 4)
  field(:CRYPTO_RELATED_STATE_COMPROMISED, 5)
  field(:CRYPTO_RELATED_STATE_DESTROYED, 6)
end
