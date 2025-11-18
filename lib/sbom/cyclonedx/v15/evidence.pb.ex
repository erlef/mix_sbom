defmodule SBoM.Cyclonedx.V15.Evidence do
  @moduledoc false

  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field(:licenses, 1, repeated: true, type: SBoM.Cyclonedx.V15.LicenseChoice)
  field(:copyright, 2, repeated: true, type: SBoM.Cyclonedx.V15.EvidenceCopyright)
  field(:identity, 3, repeated: true, type: SBoM.Cyclonedx.V15.EvidenceIdentity)
  field(:occurrences, 4, repeated: true, type: SBoM.Cyclonedx.V15.EvidenceOccurrences)
  field(:callstack, 5, proto3_optional: true, type: SBoM.Cyclonedx.V15.Callstack)
end
