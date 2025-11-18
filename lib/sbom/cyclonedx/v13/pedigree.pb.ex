defmodule SBoM.Cyclonedx.V13.Pedigree do
  @moduledoc false

  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  alias SBoM.Cyclonedx.V13.Component

  field(:ancestors, 1, repeated: true, type: Component)
  field(:descendants, 2, repeated: true, type: Component)
  field(:variants, 3, repeated: true, type: Component)
  field(:commits, 4, repeated: true, type: SBoM.Cyclonedx.V13.Commit)
  field(:patches, 5, repeated: true, type: SBoM.Cyclonedx.V13.Patch)
  field(:notes, 6, proto3_optional: true, type: :string)
end
