defmodule SBoM.CycloneDX.V17.Volume do
  @moduledoc """
  An identifiable, logical unit of data storage tied to a physical device.
  """

  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field(:uid, 1, proto3_optional: true, type: :string)
  field(:name, 2, proto3_optional: true, type: :string)
  field(:mode, 3, proto3_optional: true, type: SBoM.CycloneDX.V17.Volume.VolumeMode, enum: true)
  field(:path, 4, proto3_optional: true, type: :string)
  field(:sizeAllocated, 5, proto3_optional: true, type: :string)
  field(:persistent, 6, proto3_optional: true, type: :bool)
  field(:remote, 7, proto3_optional: true, type: :bool)
  field(:properties, 8, repeated: true, type: SBoM.CycloneDX.V17.Property)
end
