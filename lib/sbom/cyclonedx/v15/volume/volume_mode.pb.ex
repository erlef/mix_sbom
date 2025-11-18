defmodule SBoM.Cyclonedx.V15.Volume.VolumeMode do
  @moduledoc false

  use Protobuf, enum: true, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field(:VOLUME_MODE_FILESYSTEM, 0)
  field(:VOLUME_MODE_BLOCK, 1)
end
