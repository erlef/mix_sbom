defmodule SBoM.Cyclonedx.V16.Trigger.TriggerType do
  @moduledoc false

  use Protobuf, enum: true, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field(:TRIGGER_TYPE_MANUAL, 0)
  field(:TRIGGER_TYPE_API, 1)
  field(:TRIGGER_TYPE_WEBHOOK, 2)
  field(:TRIGGER_TYPE_SCHEDULED, 3)
end
