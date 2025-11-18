defmodule SBoM.Cyclonedx.V16.LicenseAcknowledgementEnumeration do
  @moduledoc false

  use Protobuf, enum: true, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field(:LICENSE_ACKNOWLEDGEMENT_ENUMERATION_UNSPECIFIED, 0)
  field(:LICENSE_ACKNOWLEDGEMENT_ENUMERATION_DECLARED, 1)
  field(:LICENSE_ACKNOWLEDGEMENT_ENUMERATION_CONCLUDED, 2)
end
