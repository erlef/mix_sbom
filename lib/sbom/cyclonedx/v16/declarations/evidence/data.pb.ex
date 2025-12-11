defmodule SBoM.CycloneDX.V16.Declarations.Evidence.Data do
  @moduledoc "CycloneDX Declarations.Evidence.Data model."
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field(:name, 1, proto3_optional: true, type: :string)

  field(:contents, 2,
    proto3_optional: true,
    type: SBoM.CycloneDX.V16.Declarations.Evidence.Data.Contents
  )

  field(:classification, 3, proto3_optional: true, type: :string)
  field(:sensitiveData, 4, repeated: true, type: :string)
  field(:governance, 5, proto3_optional: true, type: SBoM.CycloneDX.V16.DataGovernance)
end
