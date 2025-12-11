defmodule SBoM.CycloneDX.V13.OrganizationalEntity do
  @moduledoc "CycloneDX OrganizationalEntity model."
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field(:name, 1, proto3_optional: true, type: :string)
  field(:url, 2, repeated: true, type: :string)
  field(:contact, 3, repeated: true, type: SBoM.CycloneDX.V13.OrganizationalContact)
end
