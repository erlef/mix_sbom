defmodule SBoM.Cyclonedx.V17.PatentOrFamily do
  @moduledoc false

  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  oneof(:item, 0)

  field(:patent, 1, type: SBoM.Cyclonedx.V17.Patent, oneof: 0)

  field(:patent_family, 2,
    type: SBoM.Cyclonedx.V17.PatentFamily,
    json_name: "patentFamily",
    oneof: 0
  )
end
