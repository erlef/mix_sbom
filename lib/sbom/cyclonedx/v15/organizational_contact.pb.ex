defmodule SBoM.CycloneDX.V15.OrganizationalContact do
  @moduledoc "CycloneDX OrganizationalContact model."
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field(:name, 1, proto3_optional: true, type: :string)
  field(:email, 2, proto3_optional: true, type: :string)
  field(:phone, 3, proto3_optional: true, type: :string)
  field(:bom_ref, 4, proto3_optional: true, type: :string, json_name: "bomRef")
end
