defmodule SBoM.CycloneDX.V15.Evidence do
  @moduledoc "CycloneDX Evidence model."
  use Protobuf,
    full_name: "cyclonedx.v1_5.Evidence",
    protoc_gen_elixir_version: "0.16.0",
    syntax: :proto3

  field(:licenses, 1, repeated: true, type: SBoM.CycloneDX.V15.LicenseChoice)
  field(:copyright, 2, repeated: true, type: SBoM.CycloneDX.V15.EvidenceCopyright)
  field(:identity, 3, repeated: true, type: SBoM.CycloneDX.V15.EvidenceIdentity)
  field(:occurrences, 4, repeated: true, type: SBoM.CycloneDX.V15.EvidenceOccurrences)
  field(:callstack, 5, proto3_optional: true, type: SBoM.CycloneDX.V15.Callstack)
end
