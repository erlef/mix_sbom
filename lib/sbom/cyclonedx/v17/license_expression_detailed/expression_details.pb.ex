defmodule SBoM.CycloneDX.V17.LicenseExpressionDetailed.ExpressionDetails do
  @moduledoc """
  This document specifies the details and attributes related to a software license identifier. An SPDX expression may be a compound of license identifiers.
  The `license_identifier` field serves as the key that identifies each record. Note that this key is not required to be unique, as the same license identifier could apply to multiple, different but similar license details, texts, etc.
  """

  use Protobuf,
    full_name: "cyclonedx.v1_7.LicenseExpressionDetailed.ExpressionDetails",
    protoc_gen_elixir_version: "0.16.0",
    syntax: :proto3

  field(:license_identifier, 1, type: :string, json_name: "licenseIdentifier")
  field(:bom_ref, 2, proto3_optional: true, type: :string, json_name: "bomRef")
  field(:text, 3, proto3_optional: true, type: SBoM.CycloneDX.V17.AttachedText)
  field(:url, 4, proto3_optional: true, type: :string)
end
