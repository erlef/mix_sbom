defmodule SBoM.Cyclonedx.V17.CryptoProperties.CertificateState.PredefinedState do
  @moduledoc false

  use Protobuf, enum: true, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field(:PREDEFINED_STATE_UNSPECIFIED, 0)
  field(:PREDEFINED_STATE_PRE_ACTIVATION, 1)
  field(:PREDEFINED_STATE_ACTIVE, 2)
  field(:PREDEFINED_STATE_SUSPENDED, 3)
  field(:PREDEFINED_STATE_DEACTIVATED, 4)
  field(:PREDEFINED_STATE_REVOKED, 5)
  field(:PREDEFINED_STATE_DESTROYED, 6)
end
