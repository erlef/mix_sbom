defmodule SBoM.CycloneDX.V17.License do
  @moduledoc """
  Specifies the details and attributes related to a software license. It can either include a valid SPDX license identifier or a named license, along with additional properties such as license acknowledgment, comprehensive commercial licensing information, and the full text of the license.
  """

  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  oneof(:license, 0)

  field(:id, 1, type: :string, oneof: 0)
  field(:name, 2, type: :string, oneof: 0)
  field(:text, 3, proto3_optional: true, type: SBoM.CycloneDX.V17.AttachedText)
  field(:url, 4, proto3_optional: true, type: :string)
  field(:bom_ref, 5, proto3_optional: true, type: :string, json_name: "bomRef")
  field(:licensing, 6, proto3_optional: true, type: SBoM.CycloneDX.V17.Licensing)
  field(:properties, 7, repeated: true, type: SBoM.CycloneDX.V17.Property)

  field(:acknowledgement, 8,
    proto3_optional: true,
    type: SBoM.CycloneDX.V17.LicenseAcknowledgementEnumeration,
    enum: true
  )
end
