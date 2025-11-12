defmodule SBoM.Cyclonedx.V17.EnvironmentVars do
  @moduledoc false

  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  oneof(:choice, 0)

  field(:property, 1, type: SBoM.Cyclonedx.V17.Property, oneof: 0)
  field(:value, 2, type: :string, oneof: 0)
end
