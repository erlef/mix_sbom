defmodule SBoM.CycloneDX.V16.Evidence do
  @moduledoc """
  Provides the ability to document evidence collected through various forms of extraction or analysis.
  """

  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field(:licenses, 1, repeated: true, type: SBoM.CycloneDX.V16.LicenseChoice)
  field(:copyright, 2, repeated: true, type: SBoM.CycloneDX.V16.EvidenceCopyright)
  field(:identity, 3, repeated: true, type: SBoM.CycloneDX.V16.EvidenceIdentity)
  field(:occurrences, 4, repeated: true, type: SBoM.CycloneDX.V16.EvidenceOccurrences)
  field(:callstack, 5, proto3_optional: true, type: SBoM.CycloneDX.V16.Callstack)
end
