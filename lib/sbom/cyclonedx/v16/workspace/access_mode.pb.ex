defmodule SBoM.CycloneDX.V16.Workspace.AccessMode do
  @moduledoc "CycloneDX Workspace.AccessMode model."
  use Protobuf, enum: true, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field(:ACCESS_MODE_READ_ONLY, 0)
  field(:ACCESS_MODE_READ_WRITE, 1)
  field(:ACCESS_MODE_READ_WRITE_ONCE, 2)
  field(:ACCESS_MODE_WRITE_ONCE, 3)
  field(:ACCESS_MODE_WRITE_ONLY, 4)
end
