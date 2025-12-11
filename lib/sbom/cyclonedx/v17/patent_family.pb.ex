defmodule SBoM.CycloneDX.V17.PatentFamily do
  @moduledoc """
  A patent family is a group of related patent applications or granted patents that cover the same or similar invention. These patents are filed in multiple jurisdictions to protect the invention across different regions or countries. A patent family typically includes patents that share a common priority date, originating from the same initial application, and may vary slightly in scope or claims to comply with regional legal frameworks. Fields align with WIPO ST.96 standards where applicable.
  """

  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field(:bom_ref, 1, proto3_optional: true, type: :string, json_name: "bomRef")
  field(:family_id, 2, type: :string, json_name: "familyId")

  field(:priority_application, 3,
    proto3_optional: true,
    type: SBoM.CycloneDX.V17.PriorityApplication,
    json_name: "priorityApplication"
  )

  field(:members, 4, repeated: true, type: :string)

  field(:external_references, 5,
    repeated: true,
    type: SBoM.CycloneDX.V17.ExternalReference,
    json_name: "externalReferences"
  )
end
