defmodule SBoM.Cyclonedx.V17.Event do
  @moduledoc false

  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  alias SBoM.Cyclonedx.V17.ResourceReferenceChoice

  field(:uid, 1, proto3_optional: true, type: :string)
  field(:description, 2, proto3_optional: true, type: :string)
  field(:timeReceived, 3, proto3_optional: true, type: Google.Protobuf.Timestamp)
  field(:data, 4, proto3_optional: true, type: SBoM.Cyclonedx.V17.AttachedText)
  field(:source, 5, proto3_optional: true, type: ResourceReferenceChoice)
  field(:target, 6, proto3_optional: true, type: ResourceReferenceChoice)
  field(:properties, 7, repeated: true, type: SBoM.Cyclonedx.V17.Property)
end
