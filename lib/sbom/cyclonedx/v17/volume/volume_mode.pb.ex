defmodule SBoM.CycloneDX.V17.Volume.VolumeMode do
  @moduledoc "CycloneDX Volume.VolumeMode model."
  use Protobuf,
    enum: true,
    full_name: "cyclonedx.v1_7.Volume.VolumeMode",
    protoc_gen_elixir_version: "0.16.0",
    syntax: :proto3

  field(:VOLUME_MODE_FILESYSTEM, 0)
  field(:VOLUME_MODE_BLOCK, 1)
end
