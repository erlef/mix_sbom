defmodule SBoM.CycloneDX.V17.Metadata do
  @moduledoc "CycloneDX Metadata model."
  use Protobuf,
    full_name: "cyclonedx.v1_7.Metadata",
    protoc_gen_elixir_version: "0.16.0",
    syntax: :proto3

  alias SBoM.CycloneDX.V17.OrganizationalEntity

  field(:timestamp, 1, proto3_optional: true, type: Google.Protobuf.Timestamp)
  field(:tools, 2, proto3_optional: true, type: SBoM.CycloneDX.V17.Tool)
  field(:authors, 3, repeated: true, type: SBoM.CycloneDX.V17.OrganizationalContact)
  field(:component, 4, proto3_optional: true, type: SBoM.CycloneDX.V17.Component)

  field(:manufacture, 5,
    proto3_optional: true,
    type: OrganizationalEntity,
    deprecated: true
  )

  field(:supplier, 6, proto3_optional: true, type: OrganizationalEntity)
  field(:licenses, 7, repeated: true, type: SBoM.CycloneDX.V17.LicenseChoice)
  field(:properties, 8, repeated: true, type: SBoM.CycloneDX.V17.Property)
  field(:lifecycles, 9, repeated: true, type: SBoM.CycloneDX.V17.Lifecycles)
  field(:manufacturer, 10, proto3_optional: true, type: OrganizationalEntity)

  field(:distributionConstraints, 11,
    proto3_optional: true,
    type: SBoM.CycloneDX.V17.Metadata.DistributionConstraints
  )
end
