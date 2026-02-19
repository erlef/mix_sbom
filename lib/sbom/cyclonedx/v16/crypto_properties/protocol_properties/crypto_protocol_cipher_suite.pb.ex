defmodule SBoM.CycloneDX.V16.CryptoProperties.ProtocolProperties.CryptoProtocolCipherSuite do
  @moduledoc """
  Object representing a cipher suite
  """

  use Protobuf,
    full_name: "cyclonedx.v1_6.CryptoProperties.ProtocolProperties.CryptoProtocolCipherSuite",
    protoc_gen_elixir_version: "0.16.0",
    syntax: :proto3

  field(:name, 1, proto3_optional: true, type: :string)
  field(:algorithms, 2, repeated: true, type: :string)
  field(:identifiers, 3, repeated: true, type: :string)
end
