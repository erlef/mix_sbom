defmodule SBoM.Cyclonedx.V15.DataFlowDirection do
  @moduledoc false

  use Protobuf, enum: true, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field(:DATA_FLOW_NULL, 0)
  field(:DATA_FLOW_INBOUND, 1)
  field(:DATA_FLOW_OUTBOUND, 2)
  field(:DATA_FLOW_BI_DIRECTIONAL, 3)
  field(:DATA_FLOW_UNKNOWN, 4)
end
