defmodule SBoM.CycloneDX.V17.Note do
  @moduledoc """
  A note containing the locale and content.
  """

  use Protobuf,
    full_name: "cyclonedx.v1_7.Note",
    protoc_gen_elixir_version: "0.16.0",
    syntax: :proto3

  field(:locale, 1, proto3_optional: true, type: :string)
  field(:text, 2, proto3_optional: true, type: SBoM.CycloneDX.V17.AttachedText)
end
