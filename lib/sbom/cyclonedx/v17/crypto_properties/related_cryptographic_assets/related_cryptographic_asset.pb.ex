defmodule SBoM.CycloneDX.V17.CryptoProperties.RelatedCryptographicAssets.RelatedCryptographicAsset do
  @moduledoc """
  Related Cryptographic Asset
  """

  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field(:type, 1, type: :string)
  field(:ref, 2, type: :string)
end
