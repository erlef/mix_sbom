defmodule SBoM.CycloneDX.V15.Scope do
  @moduledoc "CycloneDX Scope model."
  use Protobuf,
    enum: true,
    full_name: "cyclonedx.v1_5.Scope",
    protoc_gen_elixir_version: "0.16.0",
    syntax: :proto3

  field(:SCOPE_UNSPECIFIED, 0)
  field(:SCOPE_REQUIRED, 1)
  field(:SCOPE_OPTIONAL, 2)
  field(:SCOPE_EXCLUDED, 3)
end
