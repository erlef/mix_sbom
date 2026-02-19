defmodule SBoM.CycloneDX.V16.GraphicsCollection.Graphic do
  @moduledoc "CycloneDX GraphicsCollection.Graphic model."
  use Protobuf,
    full_name: "cyclonedx.v1_6.GraphicsCollection.Graphic",
    protoc_gen_elixir_version: "0.16.0",
    syntax: :proto3

  field(:name, 1, proto3_optional: true, type: :string)
  field(:image, 2, proto3_optional: true, type: SBoM.CycloneDX.V16.AttachedText)
end
