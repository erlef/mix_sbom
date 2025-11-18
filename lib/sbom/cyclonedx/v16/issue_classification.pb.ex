defmodule SBoM.Cyclonedx.V16.IssueClassification do
  @moduledoc false

  use Protobuf, enum: true, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field(:ISSUE_CLASSIFICATION_NULL, 0)
  field(:ISSUE_CLASSIFICATION_DEFECT, 1)
  field(:ISSUE_CLASSIFICATION_ENHANCEMENT, 2)
  field(:ISSUE_CLASSIFICATION_SECURITY, 3)
end
