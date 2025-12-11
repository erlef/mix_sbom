defmodule SBoM.CycloneDX.V14.Tool do
  @moduledoc """
  Specifies a tool (manual or automated).
  """

  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field(:vendor, 1, proto3_optional: true, type: :string)
  field(:name, 2, proto3_optional: true, type: :string)
  field(:version, 3, proto3_optional: true, type: :string)
  field(:hashes, 4, repeated: true, type: SBoM.CycloneDX.V14.Hash)

  field(:external_references, 5,
    repeated: true,
    type: SBoM.CycloneDX.V14.ExternalReference,
    json_name: "externalReferences"
  )
end
