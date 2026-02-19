defmodule SBoM.CycloneDX.V16.ImpactAnalysisState do
  @moduledoc "CycloneDX ImpactAnalysisState model."
  use Protobuf,
    enum: true,
    full_name: "cyclonedx.v1_6.ImpactAnalysisState",
    protoc_gen_elixir_version: "0.16.0",
    syntax: :proto3

  field(:IMPACT_ANALYSIS_STATE_NULL, 0)
  field(:IMPACT_ANALYSIS_STATE_RESOLVED, 1)
  field(:IMPACT_ANALYSIS_STATE_RESOLVED_WITH_PEDIGREE, 2)
  field(:IMPACT_ANALYSIS_STATE_EXPLOITABLE, 3)
  field(:IMPACT_ANALYSIS_STATE_IN_TRIAGE, 4)
  field(:IMPACT_ANALYSIS_STATE_FALSE_POSITIVE, 5)
  field(:IMPACT_ANALYSIS_STATE_NOT_AFFECTED, 6)
end
