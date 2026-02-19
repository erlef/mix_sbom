defmodule SBoM.CycloneDX.V13.ExternalReference do
  @moduledoc "CycloneDX ExternalReference model."
  use Protobuf,
    full_name: "cyclonedx.v1_3.ExternalReference",
    protoc_gen_elixir_version: "0.16.0",
    syntax: :proto3

  field(:type, 1, type: SBoM.CycloneDX.V13.ExternalReferenceType, enum: true)
  field(:url, 2, type: :string)
  field(:comment, 3, proto3_optional: true, type: :string)
  field(:hashes, 4, repeated: true, type: SBoM.CycloneDX.V13.Hash)
end
