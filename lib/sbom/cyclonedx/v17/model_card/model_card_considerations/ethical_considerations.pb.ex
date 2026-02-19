defmodule SBoM.CycloneDX.V17.ModelCard.ModelCardConsiderations.EthicalConsiderations do
  @moduledoc "CycloneDX ModelCard.ModelCardConsiderations.EthicalConsiderations model."
  use Protobuf,
    full_name: "cyclonedx.v1_7.ModelCard.ModelCardConsiderations.EthicalConsiderations",
    protoc_gen_elixir_version: "0.16.0",
    syntax: :proto3

  field(:name, 1, proto3_optional: true, type: :string)
  field(:mitigationStrategy, 2, proto3_optional: true, type: :string)
end
