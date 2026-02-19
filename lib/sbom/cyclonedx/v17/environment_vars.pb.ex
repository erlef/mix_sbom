defmodule SBoM.CycloneDX.V17.EnvironmentVars do
  @moduledoc "CycloneDX EnvironmentVars model."
  use Protobuf,
    full_name: "cyclonedx.v1_7.EnvironmentVars",
    protoc_gen_elixir_version: "0.16.0",
    syntax: :proto3

  oneof(:choice, 0)

  field(:property, 1, type: SBoM.CycloneDX.V17.Property, oneof: 0)
  field(:value, 2, type: :string, oneof: 0)
end
