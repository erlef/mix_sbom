defmodule SBoM.Cyclonedx.V17.CryptoProperties.CertificateExtensions.CommonExtension do
  @moduledoc false

  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field(:name, 1,
    type: SBoM.Cyclonedx.V17.CryptoProperties.CertificateExtensions.CommonExtensionName,
    enum: true
  )

  field(:value, 2, type: :string)
end
