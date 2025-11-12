defmodule SBoM.Cyclonedx.V17.DataFlow do
  @moduledoc false

  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field(:flow, 1, type: SBoM.Cyclonedx.V17.DataFlowDirection, enum: true)
  field(:value, 2, type: :string)
  field(:name, 3, proto3_optional: true, type: :string)
  field(:description, 4, proto3_optional: true, type: :string)
  field(:source, 5, repeated: true, type: :string)
  field(:destination, 6, repeated: true, type: :string)
  field(:governance, 7, proto3_optional: true, type: SBoM.Cyclonedx.V17.DataGovernance)
end
