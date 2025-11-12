defmodule SBoM.Cyclonedx.V17.Patent do
  @moduledoc false

  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field(:bom_ref, 1, proto3_optional: true, type: :string, json_name: "bomRef")
  field(:patent_number, 2, type: :string, json_name: "patentNumber")

  field(:application_number, 3,
    proto3_optional: true,
    type: :string,
    json_name: "applicationNumber"
  )

  field(:jurisdiction, 4, type: :string)

  field(:priority_application, 5,
    proto3_optional: true,
    type: SBoM.Cyclonedx.V17.PriorityApplication,
    json_name: "priorityApplication"
  )

  field(:publication_number, 6,
    proto3_optional: true,
    type: :string,
    json_name: "publicationNumber"
  )

  field(:title, 7, proto3_optional: true, type: :string)
  field(:abstract, 8, proto3_optional: true, type: :string)

  field(:filing_date, 9,
    proto3_optional: true,
    type: Google.Protobuf.Timestamp,
    json_name: "filingDate"
  )

  field(:grant_date, 10,
    proto3_optional: true,
    type: Google.Protobuf.Timestamp,
    json_name: "grantDate"
  )

  field(:patent_expiration_date, 11,
    proto3_optional: true,
    type: Google.Protobuf.Timestamp,
    json_name: "patentExpirationDate"
  )

  field(:patent_legal_status, 12,
    type: SBoM.Cyclonedx.V17.PatentLegalStatus,
    json_name: "patentLegalStatus",
    enum: true
  )

  field(:patent_assignee, 13,
    repeated: true,
    type: SBoM.Cyclonedx.V17.OrganizationalEntityOrContact,
    json_name: "patentAssignee"
  )

  field(:external_references, 14,
    repeated: true,
    type: SBoM.Cyclonedx.V17.ExternalReference,
    json_name: "externalReferences"
  )
end
