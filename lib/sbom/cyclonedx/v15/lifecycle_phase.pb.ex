defmodule SBoM.CycloneDX.V15.LifecyclePhase do
  @moduledoc "CycloneDX LifecyclePhase model."
  use Protobuf,
    enum: true,
    full_name: "cyclonedx.v1_5.LifecyclePhase",
    protoc_gen_elixir_version: "0.16.0",
    syntax: :proto3

  field(:LIFECYCLE_PHASE_DESIGN, 0)
  field(:LIFECYCLE_PHASE_PRE_BUILD, 1)
  field(:LIFECYCLE_PHASE_BUILD, 2)
  field(:LIFECYCLE_PHASE_POST_BUILD, 3)
  field(:LIFECYCLE_PHASE_OPERATIONS, 4)
  field(:LIFECYCLE_PHASE_DISCOVERY, 5)
  field(:LIFECYCLE_PHASE_DECOMMISSION, 6)
end
