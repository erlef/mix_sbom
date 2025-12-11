defmodule SBoM.CycloneDX.V16.Declarations.Affirmation do
  @moduledoc "CycloneDX Declarations.Affirmation model."
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field(:statement, 1, proto3_optional: true, type: :string)

  field(:signatories, 2,
    repeated: true,
    type: SBoM.CycloneDX.V16.Declarations.Affirmation.Signatory
  )
end
