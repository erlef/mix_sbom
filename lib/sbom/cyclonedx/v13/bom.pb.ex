defmodule SBoM.CycloneDX.V13.Bom do
  @moduledoc "CycloneDX Bom model."
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field(:spec_version, 1, type: :string, json_name: "specVersion")
  field(:version, 2, proto3_optional: true, type: :int32)
  field(:serial_number, 3, proto3_optional: true, type: :string, json_name: "serialNumber")
  field(:metadata, 4, proto3_optional: true, type: SBoM.CycloneDX.V13.Metadata)
  field(:components, 5, repeated: true, type: SBoM.CycloneDX.V13.Component)
  field(:services, 6, repeated: true, type: SBoM.CycloneDX.V13.Service)

  field(:external_references, 7,
    repeated: true,
    type: SBoM.CycloneDX.V13.ExternalReference,
    json_name: "externalReferences"
  )

  field(:dependencies, 8, repeated: true, type: SBoM.CycloneDX.V13.Dependency)
  field(:compositions, 9, repeated: true, type: SBoM.CycloneDX.V13.Composition)
end
