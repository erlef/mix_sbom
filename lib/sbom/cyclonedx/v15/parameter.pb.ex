defmodule SBoM.CycloneDX.V15.Parameter do
  @moduledoc """
  A representation of a functional parameter.
  """

  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field(:name, 1, proto3_optional: true, type: :string)
  field(:value, 2, proto3_optional: true, type: :string)
  field(:dataType, 3, proto3_optional: true, type: :string)
end
