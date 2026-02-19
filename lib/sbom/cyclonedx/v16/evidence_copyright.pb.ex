defmodule SBoM.CycloneDX.V16.EvidenceCopyright do
  @moduledoc "CycloneDX EvidenceCopyright model."
  use Protobuf,
    full_name: "cyclonedx.v1_6.EvidenceCopyright",
    protoc_gen_elixir_version: "0.16.0",
    syntax: :proto3

  field(:text, 1, type: :string)
end
