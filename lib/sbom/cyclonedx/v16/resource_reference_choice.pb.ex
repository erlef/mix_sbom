defmodule SBoM.CycloneDX.V16.ResourceReferenceChoice do
  @moduledoc """
  Type that permits a choice to reference a resource using an iternal bom-ref identifier or an external reference.
  """

  use Protobuf,
    full_name: "cyclonedx.v1_6.ResourceReferenceChoice",
    protoc_gen_elixir_version: "0.16.0",
    syntax: :proto3

  oneof(:choice, 0)

  field(:ref, 1, type: :string, oneof: 0)
  field(:externalReference, 2, type: SBoM.CycloneDX.V16.ExternalReference, oneof: 0)
end
