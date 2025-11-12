defmodule SBoM.Cyclonedx.V17.License do
  @moduledoc false

  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  oneof(:license, 0)

  field(:id, 1, type: :string, oneof: 0)
  field(:name, 2, type: :string, oneof: 0)
  field(:text, 3, proto3_optional: true, type: SBoM.Cyclonedx.V17.AttachedText)
  field(:url, 4, proto3_optional: true, type: :string)
  field(:bom_ref, 5, proto3_optional: true, type: :string, json_name: "bomRef")
  field(:licensing, 6, proto3_optional: true, type: SBoM.Cyclonedx.V17.Licensing)
  field(:properties, 7, repeated: true, type: SBoM.Cyclonedx.V17.Property)

  field(:acknowledgement, 8,
    proto3_optional: true,
    type: SBoM.Cyclonedx.V17.LicenseAcknowledgementEnumeration,
    enum: true
  )
end
