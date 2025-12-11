defmodule SBoM.CycloneDX.V17.CryptoProperties.CertificateExtensions do
  @moduledoc """
  Certificate Extensions
  """

  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field(:extensions, 1,
    repeated: true,
    type: SBoM.CycloneDX.V17.CryptoProperties.CertificateExtensions.Extension
  )
end
