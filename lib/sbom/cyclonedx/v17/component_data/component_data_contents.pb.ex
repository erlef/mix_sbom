defmodule SBoM.CycloneDX.V17.ComponentData.ComponentDataContents do
  @moduledoc "CycloneDX ComponentData.ComponentDataContents model."
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field(:attachment, 1, proto3_optional: true, type: SBoM.CycloneDX.V17.AttachedText)
  field(:url, 2, proto3_optional: true, type: :string)
  field(:properties, 3, repeated: true, type: SBoM.CycloneDX.V17.Property)
end
