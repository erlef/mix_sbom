defmodule SBoM.CycloneDX.V16.Metadata do
  @moduledoc "CycloneDX Metadata model."
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  alias SBoM.CycloneDX.V16.OrganizationalEntity

  field(:timestamp, 1, proto3_optional: true, type: Google.Protobuf.Timestamp)
  field(:tools, 2, proto3_optional: true, type: SBoM.CycloneDX.V16.Tool)
  field(:authors, 3, repeated: true, type: SBoM.CycloneDX.V16.OrganizationalContact)
  field(:component, 4, proto3_optional: true, type: SBoM.CycloneDX.V16.Component)

  field(:manufacture, 5,
    proto3_optional: true,
    type: OrganizationalEntity,
    deprecated: true
  )

  field(:supplier, 6, proto3_optional: true, type: OrganizationalEntity)
  field(:licenses, 7, repeated: true, type: SBoM.CycloneDX.V16.LicenseChoice)
  field(:properties, 8, repeated: true, type: SBoM.CycloneDX.V16.Property)
  field(:lifecycles, 9, repeated: true, type: SBoM.CycloneDX.V16.Lifecycles)
  field(:manufacturer, 10, proto3_optional: true, type: OrganizationalEntity)
end
