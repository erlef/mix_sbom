defmodule SBoM.CycloneDX.V15.Aggregate do
  @moduledoc "CycloneDX Aggregate model."
  use Protobuf,
    enum: true,
    full_name: "cyclonedx.v1_5.Aggregate",
    protoc_gen_elixir_version: "0.16.0",
    syntax: :proto3

  field(:AGGREGATE_NOT_SPECIFIED, 0)
  field(:AGGREGATE_COMPLETE, 1)
  field(:AGGREGATE_INCOMPLETE, 2)
  field(:AGGREGATE_INCOMPLETE_FIRST_PARTY_ONLY, 3)
  field(:AGGREGATE_INCOMPLETE_THIRD_PARTY_ONLY, 4)
  field(:AGGREGATE_UNKNOWN, 5)
  field(:AGGREGATE_INCOMPLETE_FIRST_PARTY_PROPRIETARY_ONLY, 6)
  field(:AGGREGATE_INCOMPLETE_FIRST_PARTY_OPENSOURCE_ONLY, 7)
  field(:AGGREGATE_INCOMPLETE_THIRD_PARTY_PROPRIETARY_ONLY, 8)
  field(:AGGREGATE_INCOMPLETE_THIRD_PARTY_OPENSOURCE_ONLY, 9)
end
