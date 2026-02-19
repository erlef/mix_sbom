defmodule SBoM.CycloneDX.V16.Definition.Standard.Level do
  @moduledoc "CycloneDX Definition.Standard.Level model."
  use Protobuf,
    full_name: "cyclonedx.v1_6.Definition.Standard.Level",
    protoc_gen_elixir_version: "0.16.0",
    syntax: :proto3

  field(:bom_ref, 1, proto3_optional: true, type: :string, json_name: "bomRef")
  field(:identifier, 2, proto3_optional: true, type: :string)
  field(:title, 3, proto3_optional: true, type: :string)
  field(:description, 4, proto3_optional: true, type: :string)
  field(:requirements, 5, repeated: true, type: :string)
end
