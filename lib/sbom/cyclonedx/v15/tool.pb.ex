defmodule SBoM.CycloneDX.V15.Tool do
  @moduledoc """
  Specifies a tool (manual or automated).
  """

  use Protobuf,
    full_name: "cyclonedx.v1_5.Tool",
    protoc_gen_elixir_version: "0.16.0",
    syntax: :proto3

  field(:vendor, 1, proto3_optional: true, type: :string, deprecated: true)
  field(:name, 2, proto3_optional: true, type: :string, deprecated: true)
  field(:version, 3, proto3_optional: true, type: :string, deprecated: true)
  field(:hashes, 4, repeated: true, type: SBoM.CycloneDX.V15.Hash, deprecated: true)

  field(:external_references, 5,
    repeated: true,
    type: SBoM.CycloneDX.V15.ExternalReference,
    json_name: "externalReferences",
    deprecated: true
  )

  field(:components, 6, repeated: true, type: SBoM.CycloneDX.V15.Component)
  field(:services, 7, repeated: true, type: SBoM.CycloneDX.V15.Service)
end
