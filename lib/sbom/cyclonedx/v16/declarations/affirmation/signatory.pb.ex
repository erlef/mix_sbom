defmodule SBoM.CycloneDX.V16.Declarations.Affirmation.Signatory do
  @moduledoc "CycloneDX Declarations.Affirmation.Signatory model."
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field(:name, 1, proto3_optional: true, type: :string)
  field(:role, 2, proto3_optional: true, type: :string)
  field(:organization, 3, proto3_optional: true, type: SBoM.CycloneDX.V16.OrganizationalEntity)
  field(:externalReference, 4, proto3_optional: true, type: SBoM.CycloneDX.V16.ExternalReference)
end
