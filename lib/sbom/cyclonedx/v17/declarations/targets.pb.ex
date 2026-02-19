defmodule SBoM.CycloneDX.V17.Declarations.Targets do
  @moduledoc "CycloneDX Declarations.Targets model."
  use Protobuf,
    full_name: "cyclonedx.v1_7.Declarations.Targets",
    protoc_gen_elixir_version: "0.16.0",
    syntax: :proto3

  field(:organizations, 1, repeated: true, type: SBoM.CycloneDX.V17.OrganizationalEntity)
  field(:components, 2, repeated: true, type: SBoM.CycloneDX.V17.Component)
  field(:services, 3, repeated: true, type: SBoM.CycloneDX.V17.Service)
end
