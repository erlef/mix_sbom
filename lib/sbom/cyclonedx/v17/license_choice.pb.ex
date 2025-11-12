defmodule SBoM.Cyclonedx.V17.LicenseChoice do
  @moduledoc false

  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  oneof(:choice, 0)

  field(:license, 1, type: SBoM.Cyclonedx.V17.License, oneof: 0)
  field(:expression, 2, type: :string, oneof: 0)

  field(:expression_detailed, 5,
    type: SBoM.Cyclonedx.V17.LicenseExpressionDetailed,
    json_name: "expressionDetailed",
    oneof: 0
  )

  field(:acknowledgement, 3,
    proto3_optional: true,
    type: SBoM.Cyclonedx.V17.LicenseAcknowledgementEnumeration,
    enum: true
  )

  field(:bom_ref, 4, proto3_optional: true, type: :string, json_name: "bomRef")
end
