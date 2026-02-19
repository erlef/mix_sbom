defmodule SBoM.CycloneDX.V13.Tool do
  @moduledoc """
  Specifies a tool (manual or automated).
  """

  use Protobuf,
    full_name: "cyclonedx.v1_3.Tool",
    protoc_gen_elixir_version: "0.16.0",
    syntax: :proto3

  field(:vendor, 1, proto3_optional: true, type: :string)
  field(:name, 2, proto3_optional: true, type: :string)
  field(:version, 3, proto3_optional: true, type: :string)
  field(:hashes, 4, repeated: true, type: SBoM.CycloneDX.V13.Hash)
end
