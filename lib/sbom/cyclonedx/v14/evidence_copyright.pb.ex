defmodule SBoM.Cyclonedx.V14.EvidenceCopyright do
  @moduledoc false

  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field(:text, 1, type: :string)
end
