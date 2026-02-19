defmodule SBoM.CycloneDX.V17.Trigger do
  @moduledoc """
  Represents a resource that can conditionally activate (or fire) tasks based upon associated events and their data.
  """

  use Protobuf,
    full_name: "cyclonedx.v1_7.Trigger",
    protoc_gen_elixir_version: "0.16.0",
    syntax: :proto3

  field(:bom_ref, 1, type: :string, json_name: "bomRef")
  field(:uid, 2, type: :string)
  field(:name, 3, proto3_optional: true, type: :string)
  field(:description, 4, proto3_optional: true, type: :string)
  field(:properties, 5, repeated: true, type: SBoM.CycloneDX.V17.Property)
  field(:resourceReferences, 6, repeated: true, type: SBoM.CycloneDX.V17.ResourceReferenceChoice)
  field(:type, 7, type: SBoM.CycloneDX.V17.Trigger.TriggerType, enum: true)
  field(:event, 8, proto3_optional: true, type: SBoM.CycloneDX.V17.Event)
  field(:conditions, 9, repeated: true, type: SBoM.CycloneDX.V17.Condition)
  field(:timeActivated, 10, proto3_optional: true, type: Google.Protobuf.Timestamp)
  field(:inputs, 11, repeated: true, type: SBoM.CycloneDX.V17.InputType)
  field(:outputs, 12, repeated: true, type: SBoM.CycloneDX.V17.OutputType)
end
