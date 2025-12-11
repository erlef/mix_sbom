defmodule SBoM.CycloneDX.V17.Patent do
  @moduledoc """
  A patent is a legal instrument, granted by an authority, that confers certain rights over an invention for a specified period, contingent on public disclosure and adherence to relevant legal requirements. The summary information in this object is aligned with [WIPO ST.96](https://www.wipo.int/standards/en/st96/) principles where applicable.
  """

  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  alias Google.Protobuf.Timestamp

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
    type: SBoM.CycloneDX.V17.PriorityApplication,
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
    type: Timestamp,
    json_name: "filingDate"
  )

  field(:grant_date, 10,
    proto3_optional: true,
    type: Timestamp,
    json_name: "grantDate"
  )

  field(:patent_expiration_date, 11,
    proto3_optional: true,
    type: Timestamp,
    json_name: "patentExpirationDate"
  )

  field(:patent_legal_status, 12,
    type: SBoM.CycloneDX.V17.PatentLegalStatus,
    json_name: "patentLegalStatus",
    enum: true
  )

  field(:patent_assignee, 13,
    repeated: true,
    type: SBoM.CycloneDX.V17.OrganizationalEntityOrContact,
    json_name: "patentAssignee"
  )

  field(:external_references, 14,
    repeated: true,
    type: SBoM.CycloneDX.V17.ExternalReference,
    json_name: "externalReferences"
  )
end
