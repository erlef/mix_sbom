defmodule SBoM.Cyclonedx.V17.Declarations.Evidence do
  @moduledoc false

  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  alias Google.Protobuf.Timestamp
  alias SBoM.Cyclonedx.V17.OrganizationalContact

  field(:bom_ref, 1, proto3_optional: true, type: :string, json_name: "bomRef")
  field(:propertyName, 2, proto3_optional: true, type: :string)
  field(:description, 3, proto3_optional: true, type: :string)
  field(:data, 4, repeated: true, type: SBoM.Cyclonedx.V17.Declarations.Evidence.Data)
  field(:created, 5, proto3_optional: true, type: Timestamp)
  field(:expires, 6, proto3_optional: true, type: Timestamp)
  field(:author, 7, proto3_optional: true, type: OrganizationalContact)
  field(:reviewer, 8, proto3_optional: true, type: OrganizationalContact)
end
