defmodule SBoM.Cyclonedx.V17.PatentFamily do
  @moduledoc false

  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field(:bom_ref, 1, proto3_optional: true, type: :string, json_name: "bomRef")
  field(:family_id, 2, type: :string, json_name: "familyId")

  field(:priority_application, 3,
    proto3_optional: true,
    type: SBoM.Cyclonedx.V17.PriorityApplication,
    json_name: "priorityApplication"
  )

  field(:members, 4, repeated: true, type: :string)

  field(:external_references, 5,
    repeated: true,
    type: SBoM.Cyclonedx.V17.ExternalReference,
    json_name: "externalReferences"
  )
end
