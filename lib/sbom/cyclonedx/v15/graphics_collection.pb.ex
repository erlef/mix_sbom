defmodule SBoM.CycloneDX.V15.GraphicsCollection do
  @moduledoc "CycloneDX GraphicsCollection model."
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field(:description, 1, proto3_optional: true, type: :string)
  field(:graphic, 2, repeated: true, type: SBoM.CycloneDX.V15.GraphicsCollection.Graphic)
end
