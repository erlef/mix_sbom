defmodule SBoM.CycloneDX.V17.Citation do
  @moduledoc """
  Details a specific attribution of data within the BOM to a contributing entity or process.
  """

  use Protobuf,
    full_name: "cyclonedx.v1_7.Citation",
    protoc_gen_elixir_version: "0.16.0",
    syntax: :proto3

  oneof(:target, 0)

  field(:bom_ref, 1, proto3_optional: true, type: :string, json_name: "bomRef")
  field(:pointers, 2, type: SBoM.CycloneDX.V17.Citation.Pointers, oneof: 0)
  field(:expressions, 3, type: SBoM.CycloneDX.V17.Citation.Expressions, oneof: 0)
  field(:timestamp, 4, type: Google.Protobuf.Timestamp)
  field(:attributed_to, 5, proto3_optional: true, type: :string, json_name: "attributedTo")
  field(:process, 6, proto3_optional: true, type: :string)
  field(:note, 7, proto3_optional: true, type: :string)
end
