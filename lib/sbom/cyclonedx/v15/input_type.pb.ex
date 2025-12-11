defmodule SBoM.CycloneDX.V15.InputType do
  @moduledoc """
  Type that represents various input data types and formats.
  """

  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  alias SBoM.CycloneDX.V15.ResourceReferenceChoice

  field(:source, 1, proto3_optional: true, type: ResourceReferenceChoice)
  field(:target, 2, proto3_optional: true, type: ResourceReferenceChoice)
  field(:resource, 3, proto3_optional: true, type: ResourceReferenceChoice)
  field(:parameters, 4, repeated: true, type: SBoM.CycloneDX.V15.Parameter)
  field(:environmentVars, 5, repeated: true, type: SBoM.CycloneDX.V15.EnvironmentVars)
  field(:data, 6, proto3_optional: true, type: SBoM.CycloneDX.V15.AttachedText)
  field(:properties, 7, repeated: true, type: SBoM.CycloneDX.V15.Property)
end
