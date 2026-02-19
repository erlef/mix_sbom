defmodule SBoM.CycloneDX.V14.Note do
  @moduledoc "CycloneDX Note model."
  use Protobuf,
    full_name: "cyclonedx.v1_4.Note",
    protoc_gen_elixir_version: "0.16.0",
    syntax: :proto3

  field(:locale, 1, proto3_optional: true, type: :string)
  field(:text, 2, proto3_optional: true, type: SBoM.CycloneDX.V14.AttachedText)
end
