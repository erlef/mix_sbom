defmodule SBoM.Cyclonedx.V16.GraphicsCollection.Graphic do
  @moduledoc false

  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field(:name, 1, proto3_optional: true, type: :string)
  field(:image, 2, proto3_optional: true, type: SBoM.Cyclonedx.V16.AttachedText)
end
