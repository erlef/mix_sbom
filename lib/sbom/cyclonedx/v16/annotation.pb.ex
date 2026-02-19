defmodule SBoM.CycloneDX.V16.Annotation do
  @moduledoc "CycloneDX Annotation model."
  use Protobuf,
    full_name: "cyclonedx.v1_6.Annotation",
    protoc_gen_elixir_version: "0.16.0",
    syntax: :proto3

  field(:bom_ref, 1, proto3_optional: true, type: :string, json_name: "bomRef")
  field(:subjects, 2, repeated: true, type: :string)
  field(:annotator, 3, type: SBoM.CycloneDX.V16.AnnotatorChoice)
  field(:timestamp, 4, type: Google.Protobuf.Timestamp)
  field(:text, 5, type: :string)
end
