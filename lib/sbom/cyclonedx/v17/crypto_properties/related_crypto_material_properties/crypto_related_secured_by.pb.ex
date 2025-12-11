defmodule SBoM.CycloneDX.V17.CryptoProperties.RelatedCryptoMaterialProperties.CryptoRelatedSecuredBy do
  @moduledoc """
  Secured By
  """

  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field(:mechanism, 1, proto3_optional: true, type: :string)
  field(:algorithmRef, 2, proto3_optional: true, type: :string)
end
