defmodule SBoM.CycloneDX.V13.Pedigree do
  @moduledoc """
  Component pedigree is a way to document complex supply chain scenarios where components are created, distributed, modified, redistributed, combined with other components, etc. Pedigree supports viewing this complex chain from the beginning, the end, or anywhere in the middle. It also provides a way to document variants where the exact relation may not be known.
  """

  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  alias SBoM.CycloneDX.V13.Component

  field(:ancestors, 1, repeated: true, type: Component)
  field(:descendants, 2, repeated: true, type: Component)
  field(:variants, 3, repeated: true, type: Component)
  field(:commits, 4, repeated: true, type: SBoM.CycloneDX.V13.Commit)
  field(:patches, 5, repeated: true, type: SBoM.CycloneDX.V13.Patch)
  field(:notes, 6, proto3_optional: true, type: :string)
end
