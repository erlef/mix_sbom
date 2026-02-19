defmodule SBoM.CycloneDX.V16.Patch do
  @moduledoc """
  Specifies an individual patch
  """

  use Protobuf,
    full_name: "cyclonedx.v1_6.Patch",
    protoc_gen_elixir_version: "0.16.0",
    syntax: :proto3

  field(:type, 1, type: SBoM.CycloneDX.V16.PatchClassification, enum: true)
  field(:diff, 2, proto3_optional: true, type: SBoM.CycloneDX.V16.Diff)
  field(:resolves, 3, repeated: true, type: SBoM.CycloneDX.V16.Issue)
end
