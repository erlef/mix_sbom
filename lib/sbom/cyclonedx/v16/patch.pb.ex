defmodule SBoM.Cyclonedx.V16.Patch do
  @moduledoc false

  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field(:type, 1, type: SBoM.Cyclonedx.V16.PatchClassification, enum: true)
  field(:diff, 2, proto3_optional: true, type: SBoM.Cyclonedx.V16.Diff)
  field(:resolves, 3, repeated: true, type: SBoM.Cyclonedx.V16.Issue)
end
