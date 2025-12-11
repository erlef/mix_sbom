defmodule SBoM.CycloneDX.V15.OrganizationalEntity do
  @moduledoc "CycloneDX OrganizationalEntity model."
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field(:name, 1, proto3_optional: true, type: :string)
  field(:url, 2, repeated: true, type: :string)
  field(:contact, 3, repeated: true, type: SBoM.CycloneDX.V15.OrganizationalContact)
  field(:bom_ref, 4, proto3_optional: true, type: :string, json_name: "bomRef")
end
