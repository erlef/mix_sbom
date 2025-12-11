defmodule SBoM.CycloneDX.V16.DataFlowDirection do
  @moduledoc """
  Specifies the flow direction of the data. Valid values are: inbound, outbound, bi-directional, and unknown. Direction is relative to the service. Inbound flow states that data enters the service. Outbound flow states that data leaves the service. Bi-directional states that data flows both ways, and unknown states that the direction is not known.
  buf:lint:ignore ENUM_VALUE_PREFIX -- Enum value names should be prefixed with "DATA_FLOW_DIRECTION_"
  """

  use Protobuf, enum: true, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field(:DATA_FLOW_NULL, 0)
  field(:DATA_FLOW_INBOUND, 1)
  field(:DATA_FLOW_OUTBOUND, 2)
  field(:DATA_FLOW_BI_DIRECTIONAL, 3)
  field(:DATA_FLOW_UNKNOWN, 4)
end
