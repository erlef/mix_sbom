defmodule SBoM.CycloneDX.V16.DataFlow do
  @moduledoc """
  Specifies the data flow.
  """

  use Protobuf,
    full_name: "cyclonedx.v1_6.DataFlow",
    protoc_gen_elixir_version: "0.16.0",
    syntax: :proto3

  field(:flow, 1, type: SBoM.CycloneDX.V16.DataFlowDirection, enum: true)
  field(:value, 2, type: :string)
  field(:name, 3, proto3_optional: true, type: :string)
  field(:description, 4, proto3_optional: true, type: :string)
  field(:source, 5, repeated: true, type: :string)
  field(:destination, 6, repeated: true, type: :string)
  field(:governance, 7, proto3_optional: true, type: SBoM.CycloneDX.V16.DataGovernance)
end
