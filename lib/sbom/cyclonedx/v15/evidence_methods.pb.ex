defmodule SBoM.Cyclonedx.V15.EvidenceMethods do
  @moduledoc false

  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field(:technique, 1, type: SBoM.Cyclonedx.V15.EvidenceTechnique, enum: true)
  field(:confidence, 2, type: :float)
  field(:value, 3, proto3_optional: true, type: :string)
end
