defmodule SBoM.CycloneDX.V13.Dependency do
  @moduledoc "CycloneDX Dependency model."
  use Protobuf,
    full_name: "cyclonedx.v1_3.Dependency",
    protoc_gen_elixir_version: "0.16.0",
    syntax: :proto3

  field(:ref, 1, type: :string)
  field(:dependencies, 2, repeated: true, type: SBoM.CycloneDX.V13.Dependency)
end
