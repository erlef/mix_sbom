defmodule SBoM.CycloneDX.V15.Composition do
  @moduledoc "CycloneDX Composition model."
  use Protobuf,
    full_name: "cyclonedx.v1_5.Composition",
    protoc_gen_elixir_version: "0.16.0",
    syntax: :proto3

  field(:aggregate, 1, type: SBoM.CycloneDX.V15.Aggregate, enum: true)
  field(:assemblies, 2, repeated: true, type: :string)
  field(:dependencies, 3, repeated: true, type: :string)
  field(:vulnerabilities, 4, repeated: true, type: :string)
  field(:bom_ref, 5, proto3_optional: true, type: :string, json_name: "bomRef")
end
