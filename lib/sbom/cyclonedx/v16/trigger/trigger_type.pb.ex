defmodule SBoM.CycloneDX.V16.Trigger.TriggerType do
  @moduledoc "CycloneDX Trigger.TriggerType model."
  use Protobuf,
    enum: true,
    full_name: "cyclonedx.v1_6.Trigger.TriggerType",
    protoc_gen_elixir_version: "0.16.0",
    syntax: :proto3

  field(:TRIGGER_TYPE_MANUAL, 0)
  field(:TRIGGER_TYPE_API, 1)
  field(:TRIGGER_TYPE_WEBHOOK, 2)
  field(:TRIGGER_TYPE_SCHEDULED, 3)
end
