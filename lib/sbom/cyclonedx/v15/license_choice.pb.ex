defmodule SBoM.Cyclonedx.V15.LicenseChoice do
  @moduledoc false

  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  oneof(:choice, 0)

  field(:license, 1, type: SBoM.Cyclonedx.V15.License, oneof: 0)
  field(:expression, 2, type: :string, oneof: 0)
end
