defmodule SBoM.CycloneDX.V13.Patch do
  @moduledoc "CycloneDX Patch model."
  use Protobuf,
    full_name: "cyclonedx.v1_3.Patch",
    protoc_gen_elixir_version: "0.16.0",
    syntax: :proto3

  field(:type, 1, type: SBoM.CycloneDX.V13.PatchClassification, enum: true)
  field(:diff, 2, proto3_optional: true, type: SBoM.CycloneDX.V13.Diff)
  field(:resolves, 3, repeated: true, type: SBoM.CycloneDX.V13.Issue)
end
