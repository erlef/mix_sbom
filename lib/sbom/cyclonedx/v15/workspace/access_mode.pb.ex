defmodule SBoM.CycloneDX.V15.Workspace.AccessMode do
  @moduledoc "CycloneDX Workspace.AccessMode model."
  use Protobuf,
    enum: true,
    full_name: "cyclonedx.v1_5.Workspace.AccessMode",
    protoc_gen_elixir_version: "0.16.0",
    syntax: :proto3

  field(:ACCESS_MODE_READ_ONLY, 0)
  field(:ACCESS_MODE_READ_WRITE, 1)
  field(:ACCESS_MODE_READ_WRITE_ONCE, 2)
  field(:ACCESS_MODE_WRITE_ONCE, 3)
  field(:ACCESS_MODE_WRITE_ONLY, 4)
end
