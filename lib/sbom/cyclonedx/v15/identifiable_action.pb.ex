defmodule SBoM.CycloneDX.V15.IdentifiableAction do
  @moduledoc "CycloneDX IdentifiableAction model."
  use Protobuf,
    full_name: "cyclonedx.v1_5.IdentifiableAction",
    protoc_gen_elixir_version: "0.16.0",
    syntax: :proto3

  field(:timestamp, 1, proto3_optional: true, type: Google.Protobuf.Timestamp)
  field(:name, 2, proto3_optional: true, type: :string)
  field(:email, 3, proto3_optional: true, type: :string)
end
