defmodule SBoM.CycloneDX.V17.CryptoProperties.CertificateExtensions.CustomExtension do
  @moduledoc """
  Custom extension with user-defined name
  """

  use Protobuf,
    full_name: "cyclonedx.v1_7.CryptoProperties.CertificateExtensions.CustomExtension",
    protoc_gen_elixir_version: "0.16.0",
    syntax: :proto3

  field(:name, 1, type: :string)
  field(:value, 2, proto3_optional: true, type: :string)
end
