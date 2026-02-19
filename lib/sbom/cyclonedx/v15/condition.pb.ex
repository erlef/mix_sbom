defmodule SBoM.CycloneDX.V15.Condition do
  @moduledoc """
  A condition that was used to determine a trigger should be activated.
  """

  use Protobuf,
    full_name: "cyclonedx.v1_5.Condition",
    protoc_gen_elixir_version: "0.16.0",
    syntax: :proto3

  field(:description, 1, proto3_optional: true, type: :string)
  field(:expression, 2, proto3_optional: true, type: :string)
  field(:properties, 3, repeated: true, type: SBoM.CycloneDX.V15.Property)
end
