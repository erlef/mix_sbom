defmodule SBoM.Cyclonedx.V15.Advisory do
  @moduledoc false

  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field(:title, 1, proto3_optional: true, type: :string)
  field(:url, 2, type: :string)
end
