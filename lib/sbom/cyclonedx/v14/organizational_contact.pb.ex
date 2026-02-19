defmodule SBoM.CycloneDX.V14.OrganizationalContact do
  @moduledoc "CycloneDX OrganizationalContact model."
  use Protobuf,
    full_name: "cyclonedx.v1_4.OrganizationalContact",
    protoc_gen_elixir_version: "0.16.0",
    syntax: :proto3

  field(:name, 1, proto3_optional: true, type: :string)
  field(:email, 2, proto3_optional: true, type: :string)
  field(:phone, 3, proto3_optional: true, type: :string)
end
