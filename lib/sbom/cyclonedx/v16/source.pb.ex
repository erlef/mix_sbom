defmodule SBoM.CycloneDX.V16.Source do
  @moduledoc """
  The source of the issue where it is documented.
  """

  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field(:name, 1, proto3_optional: true, type: :string)
  field(:url, 2, proto3_optional: true, type: :string)
end
