defmodule SBoM.Cyclonedx.V17.LicenseExpressionDetailed.ExpressionDetails do
  @moduledoc false

  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field(:license_identifier, 1, type: :string, json_name: "licenseIdentifier")
  field(:bom_ref, 2, proto3_optional: true, type: :string, json_name: "bomRef")
  field(:text, 3, proto3_optional: true, type: SBoM.Cyclonedx.V17.AttachedText)
  field(:url, 4, proto3_optional: true, type: :string)
end
