defmodule SBoM.Cyclonedx.V17.Tool do
  @moduledoc false

  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field(:vendor, 1, proto3_optional: true, type: :string, deprecated: true)
  field(:name, 2, proto3_optional: true, type: :string, deprecated: true)
  field(:version, 3, proto3_optional: true, type: :string, deprecated: true)
  field(:hashes, 4, repeated: true, type: SBoM.Cyclonedx.V17.Hash, deprecated: true)

  field(:external_references, 5,
    repeated: true,
    type: SBoM.Cyclonedx.V17.ExternalReference,
    json_name: "externalReferences",
    deprecated: true
  )

  field(:components, 6, repeated: true, type: SBoM.Cyclonedx.V17.Component)
  field(:services, 7, repeated: true, type: SBoM.Cyclonedx.V17.Service)
end
