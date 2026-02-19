defmodule SBoM.CycloneDX.V17.PatentAssertionType do
  @moduledoc """
  The type of assertion being made about the patent or patent family. Examples include ownership, licensing, and standards inclusion.
  """

  use Protobuf,
    enum: true,
    full_name: "cyclonedx.v1_7.PatentAssertionType",
    protoc_gen_elixir_version: "0.16.0",
    syntax: :proto3

  field(:PATENT_ASSERTION_TYPE_UNSPECIFIED, 0)
  field(:PATENT_ASSERTION_TYPE_OWNERSHIP, 1)
  field(:PATENT_ASSERTION_TYPE_LICENSE, 2)
  field(:PATENT_ASSERTION_TYPE_THIRD_PARTY_CLAIM, 3)
  field(:PATENT_ASSERTION_TYPE_STANDARDS_INCLUSION, 4)
  field(:PATENT_ASSERTION_TYPE_PRIOR_ART, 5)
  field(:PATENT_ASSERTION_TYPE_EXCLUSIVE_RIGHTS, 6)
  field(:PATENT_ASSERTION_TYPE_NON_ASSERTION, 7)
  field(:PATENT_ASSERTION_TYPE_RESEARCH_OR_EVALUATION, 8)
end
