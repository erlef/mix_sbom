defmodule SBoM.CycloneDX.V15.Lifecycles do
  @moduledoc "CycloneDX Lifecycles model."
  use Protobuf,
    full_name: "cyclonedx.v1_5.Lifecycles",
    protoc_gen_elixir_version: "0.16.0",
    syntax: :proto3

  oneof(:choice, 0)

  field(:phase, 1, type: SBoM.CycloneDX.V15.LifecyclePhase, enum: true, oneof: 0)
  field(:name, 2, type: :string, oneof: 0)
  field(:description, 3, proto3_optional: true, type: :string)
end
