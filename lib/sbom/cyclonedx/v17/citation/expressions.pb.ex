defmodule SBoM.CycloneDX.V17.Citation.Expressions do
  @moduledoc "CycloneDX Citation.Expressions model."
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field(:expression, 1, repeated: true, type: :string)
end
