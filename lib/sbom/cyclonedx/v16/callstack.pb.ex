defmodule SBoM.CycloneDX.V16.Callstack do
  @moduledoc "CycloneDX Callstack model."
  use Protobuf,
    full_name: "cyclonedx.v1_6.Callstack",
    protoc_gen_elixir_version: "0.16.0",
    syntax: :proto3

  field(:frames, 1, repeated: true, type: SBoM.CycloneDX.V16.Callstack.Frames)
end
