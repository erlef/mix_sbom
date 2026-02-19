defmodule SBoM.CycloneDX.V15.Bom do
  @moduledoc "CycloneDX Bom model."
  use Protobuf,
    full_name: "cyclonedx.v1_5.Bom",
    protoc_gen_elixir_version: "0.16.0",
    syntax: :proto3

  field(:spec_version, 1, type: :string, json_name: "specVersion")
  field(:version, 2, proto3_optional: true, type: :int32)
  field(:serial_number, 3, proto3_optional: true, type: :string, json_name: "serialNumber")
  field(:metadata, 4, proto3_optional: true, type: SBoM.CycloneDX.V15.Metadata)
  field(:components, 5, repeated: true, type: SBoM.CycloneDX.V15.Component)
  field(:services, 6, repeated: true, type: SBoM.CycloneDX.V15.Service)

  field(:external_references, 7,
    repeated: true,
    type: SBoM.CycloneDX.V15.ExternalReference,
    json_name: "externalReferences"
  )

  field(:dependencies, 8, repeated: true, type: SBoM.CycloneDX.V15.Dependency)
  field(:compositions, 9, repeated: true, type: SBoM.CycloneDX.V15.Composition)
  field(:vulnerabilities, 10, repeated: true, type: SBoM.CycloneDX.V15.Vulnerability)
  field(:annotations, 11, repeated: true, type: SBoM.CycloneDX.V15.Annotation)
  field(:properties, 12, repeated: true, type: SBoM.CycloneDX.V15.Property)
  field(:formulation, 13, repeated: true, type: SBoM.CycloneDX.V15.Formula)
end
