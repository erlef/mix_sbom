defmodule SBoM.Cyclonedx.V17.Metadata.DistributionConstraints do
  @moduledoc false

  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field(:tlp, 1, proto3_optional: true, type: SBoM.Cyclonedx.V17.TlpClassification, enum: true)
end
