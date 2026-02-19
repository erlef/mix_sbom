defmodule SBoM.CycloneDX.V17.Citation.Pointers do
  @moduledoc "CycloneDX Citation.Pointers model."
  use Protobuf,
    full_name: "cyclonedx.v1_7.Citation.Pointers",
    protoc_gen_elixir_version: "0.16.0",
    syntax: :proto3

  field(:pointer, 1, repeated: true, type: :string)
end
