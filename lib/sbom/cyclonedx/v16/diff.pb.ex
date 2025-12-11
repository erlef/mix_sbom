defmodule SBoM.CycloneDX.V16.Diff do
  @moduledoc """
  The patch file (or diff) that shows changes. Refer to https://en.wikipedia.org/wiki/Diff
  """

  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field(:text, 1, proto3_optional: true, type: SBoM.CycloneDX.V16.AttachedText)
  field(:url, 2, proto3_optional: true, type: :string)
end
