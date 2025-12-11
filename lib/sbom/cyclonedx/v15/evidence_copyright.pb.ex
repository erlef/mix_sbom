defmodule SBoM.CycloneDX.V15.EvidenceCopyright do
  @moduledoc "CycloneDX EvidenceCopyright model."
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field(:text, 1, type: :string)
end
