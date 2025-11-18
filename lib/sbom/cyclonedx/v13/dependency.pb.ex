defmodule SBoM.Cyclonedx.V13.Dependency do
  @moduledoc false

  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field(:ref, 1, type: :string)
  field(:dependencies, 2, repeated: true, type: SBoM.Cyclonedx.V13.Dependency)
end
