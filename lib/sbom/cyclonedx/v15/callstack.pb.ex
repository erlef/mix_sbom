defmodule SBoM.CycloneDX.V15.Callstack do
  @moduledoc """
  Evidence of the components use through the callstack.
  """

  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field(:frames, 1, repeated: true, type: SBoM.CycloneDX.V15.Callstack.Frames)
end
