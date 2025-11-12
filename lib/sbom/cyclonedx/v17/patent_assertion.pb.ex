defmodule SBoM.Cyclonedx.V17.PatentAssertion do
  @moduledoc false

  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field(:bom_ref, 1, proto3_optional: true, type: :string, json_name: "bomRef")

  field(:assertion_type, 2,
    type: SBoM.Cyclonedx.V17.PatentAssertionType,
    json_name: "assertionType",
    enum: true
  )

  field(:patent_refs, 3, repeated: true, type: :string, json_name: "patentRefs")
  field(:asserter, 4, type: SBoM.Cyclonedx.V17.Asserter)
  field(:notes, 5, type: :string)
end
