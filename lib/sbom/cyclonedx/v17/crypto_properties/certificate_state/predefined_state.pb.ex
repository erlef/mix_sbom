defmodule SBoM.CycloneDX.V17.CryptoProperties.CertificateState.PredefinedState do
  @moduledoc """
  Pre-defined certificate states
  """

  use Protobuf,
    enum: true,
    full_name: "cyclonedx.v1_7.CryptoProperties.CertificateState.PredefinedState",
    protoc_gen_elixir_version: "0.16.0",
    syntax: :proto3

  field(:PREDEFINED_STATE_UNSPECIFIED, 0)
  field(:PREDEFINED_STATE_PRE_ACTIVATION, 1)
  field(:PREDEFINED_STATE_ACTIVE, 2)
  field(:PREDEFINED_STATE_SUSPENDED, 3)
  field(:PREDEFINED_STATE_DEACTIVATED, 4)
  field(:PREDEFINED_STATE_REVOKED, 5)
  field(:PREDEFINED_STATE_DESTROYED, 6)
end
