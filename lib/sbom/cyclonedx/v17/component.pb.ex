defmodule SBoM.CycloneDX.V17.Component do
  @moduledoc "CycloneDX Component model."
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  alias SBoM.CycloneDX.V17.OrganizationalEntity

  field(:type, 1, type: SBoM.CycloneDX.V17.Classification, enum: true)
  field(:mime_type, 2, proto3_optional: true, type: :string, json_name: "mimeType")
  field(:bom_ref, 3, proto3_optional: true, type: :string, json_name: "bomRef")
  field(:supplier, 4, proto3_optional: true, type: OrganizationalEntity)
  field(:author, 5, proto3_optional: true, type: :string, deprecated: true)
  field(:publisher, 6, proto3_optional: true, type: :string)
  field(:group, 7, proto3_optional: true, type: :string)
  field(:name, 8, type: :string)
  field(:version, 9, type: :string)
  field(:versionRange, 33, proto3_optional: true, type: :string)
  field(:description, 10, proto3_optional: true, type: :string)
  field(:scope, 11, proto3_optional: true, type: SBoM.CycloneDX.V17.Scope, enum: true)
  field(:hashes, 12, repeated: true, type: SBoM.CycloneDX.V17.Hash)
  field(:licenses, 13, repeated: true, type: SBoM.CycloneDX.V17.LicenseChoice)
  field(:copyright, 14, proto3_optional: true, type: :string)
  field(:cpe, 15, proto3_optional: true, type: :string)
  field(:purl, 16, proto3_optional: true, type: :string)
  field(:swid, 17, proto3_optional: true, type: SBoM.CycloneDX.V17.Swid)
  field(:modified, 18, proto3_optional: true, type: :bool)
  field(:pedigree, 19, proto3_optional: true, type: SBoM.CycloneDX.V17.Pedigree)

  field(:external_references, 20,
    repeated: true,
    type: SBoM.CycloneDX.V17.ExternalReference,
    json_name: "externalReferences"
  )

  field(:components, 21, repeated: true, type: SBoM.CycloneDX.V17.Component)
  field(:properties, 22, repeated: true, type: SBoM.CycloneDX.V17.Property)
  field(:evidence, 23, proto3_optional: true, type: SBoM.CycloneDX.V17.Evidence)
  field(:releaseNotes, 24, proto3_optional: true, type: SBoM.CycloneDX.V17.ReleaseNotes)
  field(:modelCard, 25, proto3_optional: true, type: SBoM.CycloneDX.V17.ModelCard)
  field(:data, 26, repeated: true, type: SBoM.CycloneDX.V17.ComponentData)
  field(:cryptoProperties, 27, proto3_optional: true, type: SBoM.CycloneDX.V17.CryptoProperties)
  field(:manufacturer, 28, proto3_optional: true, type: OrganizationalEntity)
  field(:authors, 29, repeated: true, type: SBoM.CycloneDX.V17.OrganizationalContact)
  field(:tags, 30, repeated: true, type: :string)
  field(:omniborId, 31, repeated: true, type: :string)
  field(:swhid, 32, repeated: true, type: :string)
  field(:isExternal, 34, proto3_optional: true, type: :bool)

  field(:patent_assertions, 35,
    repeated: true,
    type: SBoM.CycloneDX.V17.PatentAssertion,
    json_name: "patentAssertions"
  )
end
