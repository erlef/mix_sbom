defmodule SBoM.CycloneDX.V14.Metadata do
  @moduledoc "CycloneDX Metadata model."
  use Protobuf,
    full_name: "cyclonedx.v1_4.Metadata",
    protoc_gen_elixir_version: "0.16.0",
    syntax: :proto3

  alias SBoM.CycloneDX.V14.OrganizationalEntity

  field(:timestamp, 1, proto3_optional: true, type: Google.Protobuf.Timestamp)
  field(:tools, 2, repeated: true, type: SBoM.CycloneDX.V14.Tool)
  field(:authors, 3, repeated: true, type: SBoM.CycloneDX.V14.OrganizationalContact)
  field(:component, 4, proto3_optional: true, type: SBoM.CycloneDX.V14.Component)
  field(:manufacture, 5, proto3_optional: true, type: OrganizationalEntity)
  field(:supplier, 6, proto3_optional: true, type: OrganizationalEntity)
  field(:licenses, 7, proto3_optional: true, type: SBoM.CycloneDX.V14.LicenseChoice)
  field(:properties, 8, repeated: true, type: SBoM.CycloneDX.V14.Property)
end
