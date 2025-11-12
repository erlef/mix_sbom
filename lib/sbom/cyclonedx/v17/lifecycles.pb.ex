defmodule SBoM.Cyclonedx.V17.Lifecycles do
  @moduledoc false

  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  oneof(:choice, 0)

  field(:phase, 1, type: SBoM.Cyclonedx.V17.LifecyclePhase, enum: true, oneof: 0)
  field(:name, 2, type: :string, oneof: 0)
  field(:description, 3, proto3_optional: true, type: :string)
end
