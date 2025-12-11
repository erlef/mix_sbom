defmodule SBoM.CycloneDX.V15.Note do
  @moduledoc "CycloneDX Note model."
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field(:locale, 1, proto3_optional: true, type: :string)
  field(:text, 2, proto3_optional: true, type: SBoM.CycloneDX.V15.AttachedText)
end
