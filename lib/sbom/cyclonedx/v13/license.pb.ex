defmodule SBoM.CycloneDX.V13.License do
  @moduledoc "CycloneDX License model."
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  oneof(:license, 0)

  field(:id, 1, type: :string, oneof: 0)
  field(:name, 2, type: :string, oneof: 0)
  field(:text, 3, proto3_optional: true, type: SBoM.CycloneDX.V13.AttachedText)
  field(:url, 4, proto3_optional: true, type: :string)
end
