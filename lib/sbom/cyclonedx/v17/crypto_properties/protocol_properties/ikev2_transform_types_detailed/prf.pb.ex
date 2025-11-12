defmodule SBoM.Cyclonedx.V17.CryptoProperties.ProtocolProperties.Ikev2TransformTypesDetailed.Prf do
  @moduledoc false

  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field(:name, 1, proto3_optional: true, type: :string)
  field(:algorithm, 2, proto3_optional: true, type: :string)
end
