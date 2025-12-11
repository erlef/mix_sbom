defmodule SBoM.CycloneDX.V14.Evidence do
  @moduledoc "CycloneDX Evidence model."
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field(:licenses, 1, repeated: true, type: SBoM.CycloneDX.V14.LicenseChoice)
  field(:copyright, 2, repeated: true, type: SBoM.CycloneDX.V14.EvidenceCopyright)
end
