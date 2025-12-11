defmodule SBoM.CycloneDX.V16.Definition do
  @moduledoc "CycloneDX Definition model."
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field(:standards, 1, repeated: true, type: SBoM.CycloneDX.V16.Definition.Standard)
end
