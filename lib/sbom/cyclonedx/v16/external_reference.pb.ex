defmodule SBoM.CycloneDX.V16.ExternalReference do
  @moduledoc """
  External references provide a way to document systems, sites, and information that may be relevant but are not included with the BOM. They may also establish specific relationships within or external to the BOM.
  """

  use Protobuf,
    full_name: "cyclonedx.v1_6.ExternalReference",
    protoc_gen_elixir_version: "0.16.0",
    syntax: :proto3

  field(:type, 1, type: SBoM.CycloneDX.V16.ExternalReferenceType, enum: true)
  field(:url, 2, type: :string)
  field(:comment, 3, proto3_optional: true, type: :string)
  field(:hashes, 4, repeated: true, type: SBoM.CycloneDX.V16.Hash)
end
