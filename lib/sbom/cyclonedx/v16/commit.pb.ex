defmodule SBoM.CycloneDX.V16.Commit do
  @moduledoc "CycloneDX Commit model."
  use Protobuf,
    full_name: "cyclonedx.v1_6.Commit",
    protoc_gen_elixir_version: "0.16.0",
    syntax: :proto3

  alias SBoM.CycloneDX.V16.IdentifiableAction

  field(:uid, 1, proto3_optional: true, type: :string)
  field(:url, 2, proto3_optional: true, type: :string)
  field(:author, 3, proto3_optional: true, type: IdentifiableAction)
  field(:committer, 4, proto3_optional: true, type: IdentifiableAction)
  field(:message, 5, proto3_optional: true, type: :string)
end
