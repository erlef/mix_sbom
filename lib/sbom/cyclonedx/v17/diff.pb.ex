defmodule SBoM.CycloneDX.V17.Diff do
  @moduledoc """
  The patch file (or diff) that shows changes. Refer to https://en.wikipedia.org/wiki/Diff
  """

  use Protobuf,
    full_name: "cyclonedx.v1_7.Diff",
    protoc_gen_elixir_version: "0.16.0",
    syntax: :proto3

  field(:text, 1, proto3_optional: true, type: SBoM.CycloneDX.V17.AttachedText)
  field(:url, 2, proto3_optional: true, type: :string)
end
