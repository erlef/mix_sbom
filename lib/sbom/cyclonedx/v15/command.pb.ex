defmodule SBoM.CycloneDX.V15.Command do
  @moduledoc "CycloneDX Command model."
  use Protobuf,
    full_name: "cyclonedx.v1_5.Command",
    protoc_gen_elixir_version: "0.16.0",
    syntax: :proto3

  field(:executed, 1, proto3_optional: true, type: :string)
  field(:properties, 2, repeated: true, type: SBoM.CycloneDX.V15.Property)
end
