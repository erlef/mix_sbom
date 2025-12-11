defmodule SBoM.CycloneDX.V17.Scope do
  @moduledoc "CycloneDX Scope model."
  use Protobuf, enum: true, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field(:SCOPE_UNSPECIFIED, 0)
  field(:SCOPE_REQUIRED, 1)
  field(:SCOPE_OPTIONAL, 2)
  field(:SCOPE_EXCLUDED, 3)
end
