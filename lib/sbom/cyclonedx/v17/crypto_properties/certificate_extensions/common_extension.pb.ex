defmodule SBoM.CycloneDX.V17.CryptoProperties.CertificateExtensions.CommonExtension do
  @moduledoc """
  Common extension with predefined name
  """

  use Protobuf,
    full_name: "cyclonedx.v1_7.CryptoProperties.CertificateExtensions.CommonExtension",
    protoc_gen_elixir_version: "0.16.0",
    syntax: :proto3

  field(:name, 1,
    type: SBoM.CycloneDX.V17.CryptoProperties.CertificateExtensions.CommonExtensionName,
    enum: true
  )

  field(:value, 2, type: :string)
end
