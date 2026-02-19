defmodule SBoM.CycloneDX.V17.CryptoProperties.CertificateExtensions do
  @moduledoc """
  Certificate Extensions
  """

  use Protobuf,
    full_name: "cyclonedx.v1_7.CryptoProperties.CertificateExtensions",
    protoc_gen_elixir_version: "0.16.0",
    syntax: :proto3

  field(:extensions, 1,
    repeated: true,
    type: SBoM.CycloneDX.V17.CryptoProperties.CertificateExtensions.Extension
  )
end
