defmodule SBoM.CycloneDX.V15.Swid do
  @moduledoc "CycloneDX Swid model."
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field(:tag_id, 1, type: :string, json_name: "tagId")
  field(:name, 2, type: :string)
  field(:version, 3, proto3_optional: true, type: :string)
  field(:tag_version, 4, proto3_optional: true, type: :int32, json_name: "tagVersion")
  field(:patch, 5, proto3_optional: true, type: :bool)
  field(:text, 6, proto3_optional: true, type: SBoM.CycloneDX.V15.AttachedText)
  field(:url, 7, proto3_optional: true, type: :string)
end
