defmodule SBoM.CycloneDX.V17.Advisory do
  @moduledoc """
  Title and location where advisory information can be obtained. An advisory is a notification of a threat to a component, service, or system.
  """

  use Protobuf,
    full_name: "cyclonedx.v1_7.Advisory",
    protoc_gen_elixir_version: "0.16.0",
    syntax: :proto3

  field(:title, 1, proto3_optional: true, type: :string)
  field(:url, 2, type: :string)
end
