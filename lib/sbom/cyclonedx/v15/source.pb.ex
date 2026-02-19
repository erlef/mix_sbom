defmodule SBoM.CycloneDX.V15.Source do
  @moduledoc """
  The source of the issue where it is documented.
  """

  use Protobuf,
    full_name: "cyclonedx.v1_5.Source",
    protoc_gen_elixir_version: "0.16.0",
    syntax: :proto3

  field(:name, 1, proto3_optional: true, type: :string)
  field(:url, 2, proto3_optional: true, type: :string)
end
