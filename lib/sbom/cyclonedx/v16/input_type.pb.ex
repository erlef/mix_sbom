defmodule SBoM.CycloneDX.V16.InputType do
  @moduledoc """
  Type that represents various input data types and formats.
  """

  use Protobuf,
    full_name: "cyclonedx.v1_6.InputType",
    protoc_gen_elixir_version: "0.16.0",
    syntax: :proto3

  alias SBoM.CycloneDX.V16.ResourceReferenceChoice

  field(:source, 1, proto3_optional: true, type: ResourceReferenceChoice)
  field(:target, 2, proto3_optional: true, type: ResourceReferenceChoice)
  field(:resource, 3, proto3_optional: true, type: ResourceReferenceChoice)
  field(:parameters, 4, repeated: true, type: SBoM.CycloneDX.V16.Parameter)
  field(:environmentVars, 5, repeated: true, type: SBoM.CycloneDX.V16.EnvironmentVars)
  field(:data, 6, proto3_optional: true, type: SBoM.CycloneDX.V16.AttachedText)
  field(:properties, 7, repeated: true, type: SBoM.CycloneDX.V16.Property)
end
