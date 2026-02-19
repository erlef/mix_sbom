defmodule SBoM.CycloneDX.V17.Licensing do
  @moduledoc "CycloneDX Licensing model."
  use Protobuf,
    full_name: "cyclonedx.v1_7.Licensing",
    protoc_gen_elixir_version: "0.16.0",
    syntax: :proto3

  alias Google.Protobuf.Timestamp
  alias SBoM.CycloneDX.V17.OrganizationalEntityOrContact

  field(:altIds, 1, repeated: true, type: :string)

  field(:licensor, 2,
    proto3_optional: true,
    type: OrganizationalEntityOrContact
  )

  field(:licensee, 3,
    proto3_optional: true,
    type: OrganizationalEntityOrContact
  )

  field(:purchaser, 4,
    proto3_optional: true,
    type: OrganizationalEntityOrContact
  )

  field(:purchaseOrder, 5, proto3_optional: true, type: :string)
  field(:licenseTypes, 6, repeated: true, type: SBoM.CycloneDX.V17.LicensingTypeEnum, enum: true)
  field(:lastRenewal, 7, proto3_optional: true, type: Timestamp)
  field(:expiration, 8, proto3_optional: true, type: Timestamp)
end
