defmodule SBoM.CycloneDX.V16.Declarations.Targets do
  @moduledoc "CycloneDX Declarations.Targets model."
  use Protobuf,
    full_name: "cyclonedx.v1_6.Declarations.Targets",
    protoc_gen_elixir_version: "0.16.0",
    syntax: :proto3

  field(:organizations, 1, repeated: true, type: SBoM.CycloneDX.V16.OrganizationalEntity)
  field(:components, 2, repeated: true, type: SBoM.CycloneDX.V16.Component)
  field(:services, 3, repeated: true, type: SBoM.CycloneDX.V16.Service)
end
