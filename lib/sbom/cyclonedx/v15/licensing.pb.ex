defmodule SBoM.Cyclonedx.V15.Licensing do
  @moduledoc false

  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  alias Google.Protobuf.Timestamp
  alias SBoM.Cyclonedx.V15.OrganizationalEntityOrContact

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
  field(:licenseTypes, 6, repeated: true, type: SBoM.Cyclonedx.V15.LicensingTypeEnum, enum: true)
  field(:lastRenewal, 7, proto3_optional: true, type: Timestamp)
  field(:expiration, 8, proto3_optional: true, type: Timestamp)
end
