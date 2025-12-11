defmodule SBoM.CycloneDX.V17.CryptoProperties.CertificateState do
  @moduledoc """
  Certificate State
  """

  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  oneof(:state, 0)

  field(:reason, 1, proto3_optional: true, type: :string)

  field(:predefined_state, 2,
    type: SBoM.CycloneDX.V17.CryptoProperties.CertificateState.PredefinedState,
    json_name: "predefinedState",
    enum: true,
    oneof: 0
  )

  field(:name, 3, type: :string, oneof: 0)
  field(:description, 4, proto3_optional: true, type: :string)
end
