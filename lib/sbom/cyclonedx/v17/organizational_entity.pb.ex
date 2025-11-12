defmodule SBoM.Cyclonedx.V17.OrganizationalEntity do
  @moduledoc false

  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field(:name, 1, proto3_optional: true, type: :string)
  field(:url, 2, repeated: true, type: :string)
  field(:contact, 3, repeated: true, type: SBoM.Cyclonedx.V17.OrganizationalContact)
  field(:bom_ref, 4, proto3_optional: true, type: :string, json_name: "bomRef")
  field(:address, 5, proto3_optional: true, type: SBoM.Cyclonedx.V17.PostalAddressType)
end
