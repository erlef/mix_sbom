defmodule SBoM.CycloneDX.V17.Issue do
  @moduledoc """
  An individual issue that has been resolved.
  """

  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field(:type, 1, type: SBoM.CycloneDX.V17.IssueClassification, enum: true)
  field(:id, 2, proto3_optional: true, type: :string)
  field(:name, 3, proto3_optional: true, type: :string)
  field(:description, 4, proto3_optional: true, type: :string)
  field(:source, 5, proto3_optional: true, type: SBoM.CycloneDX.V17.Source)
  field(:references, 6, repeated: true, type: :string)
end
