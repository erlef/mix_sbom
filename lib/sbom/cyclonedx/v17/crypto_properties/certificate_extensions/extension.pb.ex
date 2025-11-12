defmodule SBoM.Cyclonedx.V17.CryptoProperties.CertificateExtensions.Extension do
  @moduledoc false

  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  oneof(:extension_type, 0)

  field(:commonExtension, 1,
    type: SBoM.Cyclonedx.V17.CryptoProperties.CertificateExtensions.CommonExtension,
    oneof: 0
  )

  field(:customExtension, 2,
    type: SBoM.Cyclonedx.V17.CryptoProperties.CertificateExtensions.CustomExtension,
    oneof: 0
  )
end
