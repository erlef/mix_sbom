defmodule SBoM.CycloneDX.V14.Composition do
  @moduledoc "CycloneDX Composition model."
  use Protobuf,
    full_name: "cyclonedx.v1_4.Composition",
    protoc_gen_elixir_version: "0.16.0",
    syntax: :proto3

  field(:aggregate, 1, type: SBoM.CycloneDX.V14.Aggregate, enum: true)
  field(:assemblies, 2, repeated: true, type: :string)
  field(:dependencies, 3, repeated: true, type: :string)
end
