defmodule SBoM.Cyclonedx.V15.Service do
  @moduledoc false

  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field(:bom_ref, 1, proto3_optional: true, type: :string, json_name: "bomRef")
  field(:provider, 2, proto3_optional: true, type: SBoM.Cyclonedx.V15.OrganizationalEntity)
  field(:group, 3, proto3_optional: true, type: :string)
  field(:name, 4, type: :string)
  field(:version, 5, proto3_optional: true, type: :string)
  field(:description, 6, proto3_optional: true, type: :string)
  field(:endpoints, 7, repeated: true, type: :string)
  field(:authenticated, 8, proto3_optional: true, type: :bool)
  field(:x_trust_boundary, 9, proto3_optional: true, type: :bool, json_name: "xTrustBoundary")
  field(:data, 10, repeated: true, type: SBoM.Cyclonedx.V15.DataFlow)
  field(:licenses, 11, repeated: true, type: SBoM.Cyclonedx.V15.LicenseChoice)

  field(:external_references, 12,
    repeated: true,
    type: SBoM.Cyclonedx.V15.ExternalReference,
    json_name: "externalReferences"
  )

  field(:services, 13, repeated: true, type: SBoM.Cyclonedx.V15.Service)
  field(:properties, 14, repeated: true, type: SBoM.Cyclonedx.V15.Property)
  field(:releaseNotes, 15, proto3_optional: true, type: SBoM.Cyclonedx.V15.ReleaseNotes)
  field(:trustZone, 16, proto3_optional: true, type: :string)
end
