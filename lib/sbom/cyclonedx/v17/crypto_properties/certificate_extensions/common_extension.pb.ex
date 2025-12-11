defmodule SBoM.CycloneDX.V17.CryptoProperties.CertificateExtensions.CommonExtension do
  @moduledoc """
  Common extension with predefined name
  """

  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field(:name, 1,
    type: SBoM.CycloneDX.V17.CryptoProperties.CertificateExtensions.CommonExtensionName,
    enum: true
  )

  field(:value, 2, type: :string)
end
