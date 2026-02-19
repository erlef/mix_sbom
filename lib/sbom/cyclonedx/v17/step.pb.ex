defmodule SBoM.CycloneDX.V17.Step do
  @moduledoc """
  Executes specific commands or tools in order to accomplish its owning task as part of a sequence.
  """

  use Protobuf,
    full_name: "cyclonedx.v1_7.Step",
    protoc_gen_elixir_version: "0.16.0",
    syntax: :proto3

  field(:name, 1, proto3_optional: true, type: :string)
  field(:description, 2, proto3_optional: true, type: :string)
  field(:commands, 3, repeated: true, type: SBoM.CycloneDX.V17.Command)
  field(:properties, 4, repeated: true, type: SBoM.CycloneDX.V17.Property)
end
