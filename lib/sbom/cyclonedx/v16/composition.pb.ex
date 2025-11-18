defmodule SBoM.Cyclonedx.V16.Composition do
  @moduledoc false

  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field(:aggregate, 1, type: SBoM.Cyclonedx.V16.Aggregate, enum: true)
  field(:assemblies, 2, repeated: true, type: :string)
  field(:dependencies, 3, repeated: true, type: :string)
  field(:vulnerabilities, 4, repeated: true, type: :string)
  field(:bom_ref, 5, proto3_optional: true, type: :string, json_name: "bomRef")
end
