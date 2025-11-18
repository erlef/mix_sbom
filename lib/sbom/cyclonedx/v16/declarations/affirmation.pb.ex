defmodule SBoM.Cyclonedx.V16.Declarations.Affirmation do
  @moduledoc false

  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field(:statement, 1, proto3_optional: true, type: :string)

  field(:signatories, 2,
    repeated: true,
    type: SBoM.Cyclonedx.V16.Declarations.Affirmation.Signatory
  )
end
