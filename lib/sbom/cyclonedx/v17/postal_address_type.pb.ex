defmodule SBoM.CycloneDX.V17.PostalAddressType do
  @moduledoc """
  An address used to identify a contactable location.
  """

  use Protobuf,
    full_name: "cyclonedx.v1_7.PostalAddressType",
    protoc_gen_elixir_version: "0.16.0",
    syntax: :proto3

  field(:bom_ref, 1, proto3_optional: true, type: :string, json_name: "bomRef")
  field(:country, 2, proto3_optional: true, type: :string)
  field(:region, 3, proto3_optional: true, type: :string)
  field(:locality, 4, proto3_optional: true, type: :string)
  field(:postOfficeBoxNumber, 5, proto3_optional: true, type: :string)
  field(:postalCodeue, 6, proto3_optional: true, type: :string)
  field(:streetAddress, 7, proto3_optional: true, type: :string)
end
