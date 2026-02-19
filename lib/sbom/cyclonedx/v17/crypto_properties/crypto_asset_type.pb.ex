defmodule SBoM.CycloneDX.V17.CryptoProperties.CryptoAssetType do
  @moduledoc """
  Asset Type
  """

  use Protobuf,
    enum: true,
    full_name: "cyclonedx.v1_7.CryptoProperties.CryptoAssetType",
    protoc_gen_elixir_version: "0.16.0",
    syntax: :proto3

  field(:CRYPTO_ASSET_TYPE_UNSPECIFIED, 0)
  field(:CRYPTO_ASSET_TYPE_ALGORITHM, 1)
  field(:CRYPTO_ASSET_TYPE_CERTIFICATE, 2)
  field(:CRYPTO_ASSET_TYPE_PROTOCOL, 3)
  field(:CRYPTO_ASSET_TYPE_RELATED_CRYPTO_MATERIAL, 4)
end
