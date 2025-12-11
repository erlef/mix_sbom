defmodule SBoM.CycloneDX.V14.IdentifiableAction do
  @moduledoc "CycloneDX IdentifiableAction model."
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field(:timestamp, 1, proto3_optional: true, type: Google.Protobuf.Timestamp)
  field(:name, 2, proto3_optional: true, type: :string)
  field(:email, 3, proto3_optional: true, type: :string)
end
