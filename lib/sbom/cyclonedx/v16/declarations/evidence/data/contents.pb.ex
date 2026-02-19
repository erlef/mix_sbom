defmodule SBoM.CycloneDX.V16.Declarations.Evidence.Data.Contents do
  @moduledoc "CycloneDX Declarations.Evidence.Data.Contents model."
  use Protobuf,
    full_name: "cyclonedx.v1_6.Declarations.Evidence.Data.Contents",
    protoc_gen_elixir_version: "0.16.0",
    syntax: :proto3

  field(:attachment, 1, proto3_optional: true, type: SBoM.CycloneDX.V16.AttachedText)
  field(:url, 2, proto3_optional: true, type: :string)
end
