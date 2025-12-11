defmodule SBoM.CycloneDX.V17.CryptoProperties.ProtocolProperties.Ikev2TransformTypesDetailed do
  @moduledoc """
  IKEv2 Transform Types Detailed
  """

  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field(:encr, 1,
    repeated: true,
    type: SBoM.CycloneDX.V17.CryptoProperties.ProtocolProperties.Ikev2TransformTypesDetailed.Encr
  )

  field(:prf, 2,
    repeated: true,
    type: SBoM.CycloneDX.V17.CryptoProperties.ProtocolProperties.Ikev2TransformTypesDetailed.Prf
  )

  field(:integ, 3,
    repeated: true,
    type: SBoM.CycloneDX.V17.CryptoProperties.ProtocolProperties.Ikev2TransformTypesDetailed.Integ
  )

  field(:ke, 4,
    repeated: true,
    type: SBoM.CycloneDX.V17.CryptoProperties.ProtocolProperties.Ikev2TransformTypesDetailed.Ke
  )

  field(:esn, 5, proto3_optional: true, type: :bool)

  field(:auth, 6,
    repeated: true,
    type: SBoM.CycloneDX.V17.CryptoProperties.ProtocolProperties.Ikev2TransformTypesDetailed.Auth
  )
end
