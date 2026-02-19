defmodule SBoM.CycloneDX.V17.Definition do
  @moduledoc "CycloneDX Definition model."
  use Protobuf,
    full_name: "cyclonedx.v1_7.Definition",
    protoc_gen_elixir_version: "0.16.0",
    syntax: :proto3

  field(:standards, 1, repeated: true, type: SBoM.CycloneDX.V17.Definition.Standard)
  field(:patents, 2, repeated: true, type: SBoM.CycloneDX.V17.PatentOrFamily)
end
