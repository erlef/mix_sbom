defmodule SBoM.CycloneDX.V14.Property do
  @moduledoc """
  Specifies a property
  """

  use Protobuf,
    full_name: "cyclonedx.v1_4.Property",
    protoc_gen_elixir_version: "0.16.0",
    syntax: :proto3

  field(:name, 1, type: :string)
  field(:value, 2, proto3_optional: true, type: :string)
end
