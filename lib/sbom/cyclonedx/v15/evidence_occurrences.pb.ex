defmodule SBoM.Cyclonedx.V15.EvidenceOccurrences do
  @moduledoc false

  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field(:bom_ref, 1, proto3_optional: true, type: :string, json_name: "bomRef")
  field(:location, 2, type: :string)
end
