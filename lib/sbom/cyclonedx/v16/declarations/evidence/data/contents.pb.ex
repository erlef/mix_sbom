defmodule SBoM.Cyclonedx.V16.Declarations.Evidence.Data.Contents do
  @moduledoc false

  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field(:attachment, 1, proto3_optional: true, type: SBoM.Cyclonedx.V16.AttachedText)
  field(:url, 2, proto3_optional: true, type: :string)
end
