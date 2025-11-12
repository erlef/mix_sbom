defmodule SBoM.Cyclonedx.V17.CryptoProperties.RelatedCryptographicAssets do
  @moduledoc false

  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field(:assets, 1,
    repeated: true,
    type: SBoM.Cyclonedx.V17.CryptoProperties.RelatedCryptographicAssets.RelatedCryptographicAsset
  )
end
