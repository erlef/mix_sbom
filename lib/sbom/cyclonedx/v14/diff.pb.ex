defmodule SBoM.CycloneDX.V14.Diff do
  @moduledoc "CycloneDX Diff model."
  use Protobuf,
    full_name: "cyclonedx.v1_4.Diff",
    protoc_gen_elixir_version: "0.16.0",
    syntax: :proto3

  field(:text, 1, proto3_optional: true, type: SBoM.CycloneDX.V14.AttachedText)
  field(:url, 2, proto3_optional: true, type: :string)
end
