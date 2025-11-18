defmodule SBoM.Cyclonedx.V13.Aggregate do
  @moduledoc false

  use Protobuf, enum: true, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field(:AGGREGATE_NOT_SPECIFIED, 0)
  field(:AGGREGATE_COMPLETE, 1)
  field(:AGGREGATE_INCOMPLETE, 2)
  field(:AGGREGATE_INCOMPLETE_FIRST_PARTY_ONLY, 3)
  field(:AGGREGATE_INCOMPLETE_THIRD_PARTY_ONLY, 4)
  field(:AGGREGATE_UNKNOWN, 5)
end
