defmodule SBoM.CycloneDX.V17.Callstack do
  @moduledoc "CycloneDX Callstack model."
  use Protobuf,
    full_name: "cyclonedx.v1_7.Callstack",
    protoc_gen_elixir_version: "0.16.0",
    syntax: :proto3

  field(:frames, 1, repeated: true, type: SBoM.CycloneDX.V17.Callstack.Frames)
end
