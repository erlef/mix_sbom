defmodule SBoM.CycloneDX.V15.Step do
  @moduledoc """
  Executes specific commands or tools in order to accomplish its owning task as part of a sequence.
  """

  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field(:name, 1, proto3_optional: true, type: :string)
  field(:description, 2, proto3_optional: true, type: :string)
  field(:commands, 3, repeated: true, type: SBoM.CycloneDX.V15.Command)
  field(:properties, 4, repeated: true, type: SBoM.CycloneDX.V15.Property)
end
