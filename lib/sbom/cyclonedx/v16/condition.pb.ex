defmodule SBoM.Cyclonedx.V16.Condition do
  @moduledoc false

  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field(:description, 1, proto3_optional: true, type: :string)
  field(:expression, 2, proto3_optional: true, type: :string)
  field(:properties, 3, repeated: true, type: SBoM.Cyclonedx.V16.Property)
end
