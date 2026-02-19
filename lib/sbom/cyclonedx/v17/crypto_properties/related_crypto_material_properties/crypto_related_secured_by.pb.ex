defmodule SBoM.CycloneDX.V17.CryptoProperties.RelatedCryptoMaterialProperties.CryptoRelatedSecuredBy do
  @moduledoc """
  Secured By
  """

  use Protobuf,
    full_name: "cyclonedx.v1_7.CryptoProperties.RelatedCryptoMaterialProperties.CryptoRelatedSecuredBy",
    protoc_gen_elixir_version: "0.16.0",
    syntax: :proto3

  field(:mechanism, 1, proto3_optional: true, type: :string)
  field(:algorithmRef, 2, proto3_optional: true, type: :string)
end
