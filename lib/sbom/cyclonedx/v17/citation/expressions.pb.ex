defmodule SBoM.CycloneDX.V17.Citation.Expressions do
  @moduledoc "CycloneDX Citation.Expressions model."
  use Protobuf,
    full_name: "cyclonedx.v1_7.Citation.Expressions",
    protoc_gen_elixir_version: "0.16.0",
    syntax: :proto3

  field(:expression, 1, repeated: true, type: :string)
end
