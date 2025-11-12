defmodule SBoM.Cyclonedx.V17.LicenseExpressionDetailed do
  @moduledoc false

  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field(:expression, 1, type: :string)

  field(:details, 2,
    repeated: true,
    type: SBoM.Cyclonedx.V17.LicenseExpressionDetailed.ExpressionDetails
  )

  field(:bom_ref, 3, proto3_optional: true, type: :string, json_name: "bomRef")

  field(:acknowledgement, 4,
    proto3_optional: true,
    type: SBoM.Cyclonedx.V17.LicenseAcknowledgementEnumeration,
    enum: true
  )

  field(:licensing, 5, proto3_optional: true, type: SBoM.Cyclonedx.V17.Licensing)
  field(:properties, 6, repeated: true, type: SBoM.Cyclonedx.V17.Property)
end
