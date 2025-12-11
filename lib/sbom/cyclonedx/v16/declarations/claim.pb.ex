defmodule SBoM.CycloneDX.V16.Declarations.Claim do
  @moduledoc "CycloneDX Declarations.Claim model."
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field(:bom_ref, 1, proto3_optional: true, type: :string, json_name: "bomRef")
  field(:target, 2, proto3_optional: true, type: :string)
  field(:predicate, 3, proto3_optional: true, type: :string)
  field(:mitigationStrategies, 4, repeated: true, type: :string)
  field(:reasoning, 5, proto3_optional: true, type: :string)
  field(:evidence, 6, repeated: true, type: :string)
  field(:counterEvidence, 7, repeated: true, type: :string)
  field(:externalReferences, 8, repeated: true, type: SBoM.CycloneDX.V16.ExternalReference)
end
