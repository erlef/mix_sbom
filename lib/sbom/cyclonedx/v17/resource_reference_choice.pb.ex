defmodule SBoM.CycloneDX.V17.ResourceReferenceChoice do
  @moduledoc """
  Type that permits a choice to reference a resource using an iternal bom_ref identifier or an external reference.
  """

  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  oneof(:choice, 0)

  field(:ref, 1, type: :string, oneof: 0)
  field(:externalReference, 2, type: SBoM.CycloneDX.V17.ExternalReference, oneof: 0)
end
