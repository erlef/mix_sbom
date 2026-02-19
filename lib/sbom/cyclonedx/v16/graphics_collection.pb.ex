defmodule SBoM.CycloneDX.V16.GraphicsCollection do
  @moduledoc """
  A collection of graphics that represent various measurements.
  """

  use Protobuf,
    full_name: "cyclonedx.v1_6.GraphicsCollection",
    protoc_gen_elixir_version: "0.16.0",
    syntax: :proto3

  field(:description, 1, proto3_optional: true, type: :string)
  field(:graphic, 2, repeated: true, type: SBoM.CycloneDX.V16.GraphicsCollection.Graphic)
end
