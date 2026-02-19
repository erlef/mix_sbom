defmodule SBoM.CycloneDX.V17.CryptoProperties.ProtocolProperties.Ikev2TransformTypesDetailed.Auth do
  @moduledoc """
  IKEv2 Authentication method
  """

  use Protobuf,
    full_name: "cyclonedx.v1_7.CryptoProperties.ProtocolProperties.Ikev2TransformTypesDetailed.Auth",
    protoc_gen_elixir_version: "0.16.0",
    syntax: :proto3

  field(:name, 1, proto3_optional: true, type: :string)
  field(:algorithm, 2, proto3_optional: true, type: :string)
end
