defmodule SBoM.CycloneDX.V17.CryptoProperties.RelatedCryptographicAssets do
  @moduledoc """
  Related Cryptographic Assets
  """

  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field(:assets, 1,
    repeated: true,
    type: SBoM.CycloneDX.V17.CryptoProperties.RelatedCryptographicAssets.RelatedCryptographicAsset
  )
end
