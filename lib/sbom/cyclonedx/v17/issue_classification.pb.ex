defmodule SBoM.CycloneDX.V17.IssueClassification do
  @moduledoc "CycloneDX IssueClassification model."
  use Protobuf,
    enum: true,
    full_name: "cyclonedx.v1_7.IssueClassification",
    protoc_gen_elixir_version: "0.16.0",
    syntax: :proto3

  field(:ISSUE_CLASSIFICATION_NULL, 0)
  field(:ISSUE_CLASSIFICATION_DEFECT, 1)
  field(:ISSUE_CLASSIFICATION_ENHANCEMENT, 2)
  field(:ISSUE_CLASSIFICATION_SECURITY, 3)
end
