defmodule SBoM.CycloneDX.V14.Advisory do
  @moduledoc "CycloneDX Advisory model."
  use Protobuf,
    full_name: "cyclonedx.v1_4.Advisory",
    protoc_gen_elixir_version: "0.16.0",
    syntax: :proto3

  field(:title, 1, proto3_optional: true, type: :string)
  field(:url, 2, type: :string)
end
