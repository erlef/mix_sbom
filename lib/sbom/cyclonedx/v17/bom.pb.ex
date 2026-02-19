defmodule SBoM.CycloneDX.V17.Bom do
  @moduledoc "CycloneDX Bom model."
  use Protobuf,
    full_name: "cyclonedx.v1_7.Bom",
    protoc_gen_elixir_version: "0.16.0",
    syntax: :proto3

  field(:spec_version, 1, type: :string, json_name: "specVersion")
  field(:version, 2, proto3_optional: true, type: :int32)
  field(:serial_number, 3, proto3_optional: true, type: :string, json_name: "serialNumber")
  field(:metadata, 4, proto3_optional: true, type: SBoM.CycloneDX.V17.Metadata)
  field(:components, 5, repeated: true, type: SBoM.CycloneDX.V17.Component)
  field(:services, 6, repeated: true, type: SBoM.CycloneDX.V17.Service)

  field(:external_references, 7,
    repeated: true,
    type: SBoM.CycloneDX.V17.ExternalReference,
    json_name: "externalReferences"
  )

  field(:dependencies, 8, repeated: true, type: SBoM.CycloneDX.V17.Dependency)
  field(:compositions, 9, repeated: true, type: SBoM.CycloneDX.V17.Composition)
  field(:vulnerabilities, 10, repeated: true, type: SBoM.CycloneDX.V17.Vulnerability)
  field(:annotations, 11, repeated: true, type: SBoM.CycloneDX.V17.Annotation)
  field(:properties, 12, repeated: true, type: SBoM.CycloneDX.V17.Property)
  field(:formulation, 13, repeated: true, type: SBoM.CycloneDX.V17.Formula)
  field(:declarations, 14, repeated: true, type: SBoM.CycloneDX.V17.Declarations)
  field(:definitions, 15, repeated: true, type: SBoM.CycloneDX.V17.Definition)
  field(:citations, 16, repeated: true, type: SBoM.CycloneDX.V17.Citation)
end
