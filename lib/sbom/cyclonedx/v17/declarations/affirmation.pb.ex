defmodule SBoM.CycloneDX.V17.Declarations.Affirmation do
  @moduledoc "CycloneDX Declarations.Affirmation model."
  use Protobuf,
    full_name: "cyclonedx.v1_7.Declarations.Affirmation",
    protoc_gen_elixir_version: "0.16.0",
    syntax: :proto3

  field(:statement, 1, proto3_optional: true, type: :string)

  field(:signatories, 2,
    repeated: true,
    type: SBoM.CycloneDX.V17.Declarations.Affirmation.Signatory
  )
end
