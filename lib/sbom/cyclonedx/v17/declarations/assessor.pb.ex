defmodule SBoM.CycloneDX.V17.Declarations.Assessor do
  @moduledoc "CycloneDX Declarations.Assessor model."
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field(:bom_ref, 1, proto3_optional: true, type: :string, json_name: "bomRef")
  field(:thirdParty, 2, proto3_optional: true, type: :bool)
  field(:organization, 3, proto3_optional: true, type: SBoM.CycloneDX.V17.OrganizationalEntity)
end
