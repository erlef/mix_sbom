defmodule SBoM.CycloneDX.V15.Formula do
  @moduledoc """
  Describes workflows and resources that captures rules and other aspects of how the associated BOM component or service was formed.
  """

  use Protobuf,
    full_name: "cyclonedx.v1_5.Formula",
    protoc_gen_elixir_version: "0.16.0",
    syntax: :proto3

  field(:bom_ref, 1, proto3_optional: true, type: :string, json_name: "bomRef")
  field(:components, 2, repeated: true, type: SBoM.CycloneDX.V15.Component)
  field(:services, 3, repeated: true, type: SBoM.CycloneDX.V15.Service)
  field(:workflows, 4, repeated: true, type: SBoM.CycloneDX.V15.Workflow)
  field(:properties, 5, repeated: true, type: SBoM.CycloneDX.V15.Property)
end
