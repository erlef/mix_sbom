defmodule SBoM.CycloneDX.V15.ReleaseNotes do
  @moduledoc "CycloneDX ReleaseNotes model."
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field(:type, 1, type: :string)
  field(:title, 2, proto3_optional: true, type: :string)
  field(:featuredImage, 3, proto3_optional: true, type: :string)
  field(:socialImage, 4, proto3_optional: true, type: :string)
  field(:description, 5, proto3_optional: true, type: :string)
  field(:timestamp, 6, proto3_optional: true, type: Google.Protobuf.Timestamp)
  field(:aliases, 7, repeated: true, type: :string)
  field(:tags, 8, repeated: true, type: :string)
  field(:resolves, 9, repeated: true, type: SBoM.CycloneDX.V15.Issue)
  field(:notes, 10, repeated: true, type: SBoM.CycloneDX.V15.Note)
  field(:properties, 11, repeated: true, type: SBoM.CycloneDX.V15.Property)
end
