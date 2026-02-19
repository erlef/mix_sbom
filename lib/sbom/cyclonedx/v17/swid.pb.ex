defmodule SBoM.CycloneDX.V17.Swid do
  @moduledoc """
  Specifies metadata and content for ISO-IEC 19770-2 Software Identification (SWID) Tags.
  """

  use Protobuf,
    full_name: "cyclonedx.v1_7.Swid",
    protoc_gen_elixir_version: "0.16.0",
    syntax: :proto3

  field(:tag_id, 1, type: :string, json_name: "tagId")
  field(:name, 2, type: :string)
  field(:version, 3, proto3_optional: true, type: :string)
  field(:tag_version, 4, proto3_optional: true, type: :int32, json_name: "tagVersion")
  field(:patch, 5, proto3_optional: true, type: :bool)
  field(:text, 6, proto3_optional: true, type: SBoM.CycloneDX.V17.AttachedText)
  field(:url, 7, proto3_optional: true, type: :string)
end
