defmodule SBoM.CycloneDX.V16.ModelCard.ModelCardConsiderations.EthicalConsiderations do
  @moduledoc "CycloneDX ModelCard.ModelCardConsiderations.EthicalConsiderations model."
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field(:name, 1, proto3_optional: true, type: :string)
  field(:mitigationStrategy, 2, proto3_optional: true, type: :string)
end
