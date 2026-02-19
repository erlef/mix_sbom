defmodule SBoM.CycloneDX.V17.LicenseExpressionDetailed do
  @moduledoc """
  Specifies the details and attributes related to a software license.
  It must be a valid SPDX license expression, along with additional properties such as license acknowledgment.
  """

  use Protobuf,
    full_name: "cyclonedx.v1_7.LicenseExpressionDetailed",
    protoc_gen_elixir_version: "0.16.0",
    syntax: :proto3

  field(:expression, 1, type: :string)

  field(:details, 2,
    repeated: true,
    type: SBoM.CycloneDX.V17.LicenseExpressionDetailed.ExpressionDetails
  )

  field(:bom_ref, 3, proto3_optional: true, type: :string, json_name: "bomRef")

  field(:acknowledgement, 4,
    proto3_optional: true,
    type: SBoM.CycloneDX.V17.LicenseAcknowledgementEnumeration,
    enum: true
  )

  field(:licensing, 5, proto3_optional: true, type: SBoM.CycloneDX.V17.Licensing)
  field(:properties, 6, repeated: true, type: SBoM.CycloneDX.V17.Property)
end
