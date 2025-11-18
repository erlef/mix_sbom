defmodule SBoM.Cyclonedx.V16.Definition.Standard.Requirement do
  @moduledoc false

  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field(:bom_ref, 1, proto3_optional: true, type: :string, json_name: "bomRef")
  field(:identifier, 2, proto3_optional: true, type: :string)
  field(:title, 3, proto3_optional: true, type: :string)
  field(:text, 4, proto3_optional: true, type: :string)
  field(:descriptions, 5, repeated: true, type: :string)
  field(:openCre, 6, repeated: true, type: :string)
  field(:parent, 7, proto3_optional: true, type: :string)
  field(:properties, 8, repeated: true, type: SBoM.Cyclonedx.V16.Property)
  field(:externalReferences, 9, repeated: true, type: SBoM.Cyclonedx.V16.ExternalReference)
end
