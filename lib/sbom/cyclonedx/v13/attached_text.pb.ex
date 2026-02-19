defmodule SBoM.CycloneDX.V13.AttachedText do
  @moduledoc """
  Specifies attributes of the text
  """

  use Protobuf,
    full_name: "cyclonedx.v1_3.AttachedText",
    protoc_gen_elixir_version: "0.16.0",
    syntax: :proto3

  field(:content_type, 1, proto3_optional: true, type: :string, json_name: "contentType")
  field(:encoding, 2, proto3_optional: true, type: :string)
  field(:value, 3, type: :string)
end
