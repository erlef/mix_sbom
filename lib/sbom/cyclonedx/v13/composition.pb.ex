defmodule SBoM.Cyclonedx.V13.Composition do
  @moduledoc false

  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field(:aggregate, 1, type: SBoM.Cyclonedx.V13.Aggregate, enum: true)
  field(:assemblies, 2, repeated: true, type: :string)
  field(:dependencies, 3, repeated: true, type: :string)
end
