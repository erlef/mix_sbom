defmodule SBoM.CycloneDX.V13.LicenseChoice do
  @moduledoc "CycloneDX LicenseChoice model."
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  oneof(:choice, 0)

  field(:license, 1, type: SBoM.CycloneDX.V13.License, oneof: 0)
  field(:expression, 2, type: :string, oneof: 0)
end
