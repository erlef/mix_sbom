defmodule SBoM.CycloneDX.V17.Asserter do
  @moduledoc "CycloneDX Asserter model."
  use Protobuf,
    full_name: "cyclonedx.v1_7.Asserter",
    protoc_gen_elixir_version: "0.16.0",
    syntax: :proto3

  oneof(:value, 0)

  field(:organization, 1, type: SBoM.CycloneDX.V17.OrganizationalEntity, oneof: 0)
  field(:individual, 2, type: SBoM.CycloneDX.V17.OrganizationalContact, oneof: 0)
  field(:ref, 3, type: :string, oneof: 0)
end
