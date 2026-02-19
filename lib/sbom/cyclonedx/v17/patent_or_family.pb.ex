defmodule SBoM.CycloneDX.V17.PatentOrFamily do
  @moduledoc """
  Either an individual patents or patent families.
  """

  use Protobuf,
    full_name: "cyclonedx.v1_7.PatentOrFamily",
    protoc_gen_elixir_version: "0.16.0",
    syntax: :proto3

  oneof(:item, 0)

  field(:patent, 1, type: SBoM.CycloneDX.V17.Patent, oneof: 0)

  field(:patent_family, 2,
    type: SBoM.CycloneDX.V17.PatentFamily,
    json_name: "patentFamily",
    oneof: 0
  )
end
