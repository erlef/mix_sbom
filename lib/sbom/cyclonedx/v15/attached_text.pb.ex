defmodule SBoM.Cyclonedx.V15.AttachedText do
  @moduledoc false

  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field(:content_type, 1, proto3_optional: true, type: :string, json_name: "contentType")
  field(:encoding, 2, proto3_optional: true, type: :string)
  field(:value, 3, type: :string)
end
