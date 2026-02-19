defmodule SBoM.CycloneDX.V15.LicenseChoice do
  @moduledoc "CycloneDX LicenseChoice model."
  use Protobuf,
    full_name: "cyclonedx.v1_5.LicenseChoice",
    protoc_gen_elixir_version: "0.16.0",
    syntax: :proto3

  oneof(:choice, 0)

  field(:license, 1, type: SBoM.CycloneDX.V15.License, oneof: 0)
  field(:expression, 2, type: :string, oneof: 0)
end
