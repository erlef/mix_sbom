defmodule SBoM.Cyclonedx.V16.Callstack do
  @moduledoc false

  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field(:frames, 1, repeated: true, type: SBoM.Cyclonedx.V16.Callstack.Frames)
end
