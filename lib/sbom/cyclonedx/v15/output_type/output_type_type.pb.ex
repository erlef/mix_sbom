defmodule SBoM.CycloneDX.V15.OutputType.OutputTypeType do
  @moduledoc "CycloneDX OutputType.OutputTypeType model."
  use Protobuf,
    enum: true,
    full_name: "cyclonedx.v1_5.OutputType.OutputTypeType",
    protoc_gen_elixir_version: "0.16.0",
    syntax: :proto3

  field(:OUTPUT_TYPE_ARTIFACT, 0)
  field(:OUTPUT_TYPE_ATTESTATION, 1)
  field(:OUTPUT_TYPE_LOG, 2)
  field(:OUTPUT_TYPE_EVIDENCE, 3)
  field(:OUTPUT_TYPE_METRICS, 4)
  field(:OUTPUT_TYPE_OTHER, 5)
end
