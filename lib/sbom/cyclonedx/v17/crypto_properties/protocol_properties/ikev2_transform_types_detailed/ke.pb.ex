defmodule SBoM.CycloneDX.V17.CryptoProperties.ProtocolProperties.Ikev2TransformTypesDetailed.Ke do
  @moduledoc """
  IKEv2 Key Exchange Method (KE)
  """

  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field(:group, 1, proto3_optional: true, type: :int32)
  field(:algorithm, 2, proto3_optional: true, type: :string)
end
