defmodule SBoM.CycloneDX.V16.Task do
  @moduledoc """
  Describes the inputs, sequence of steps and resources used to accomplish a task and its output.
  """

  use Protobuf,
    full_name: "cyclonedx.v1_6.Task",
    protoc_gen_elixir_version: "0.16.0",
    syntax: :proto3

  alias Google.Protobuf.Timestamp

  field(:bom_ref, 1, type: :string, json_name: "bomRef")
  field(:uid, 2, type: :string)
  field(:name, 3, proto3_optional: true, type: :string)
  field(:description, 4, proto3_optional: true, type: :string)
  field(:properties, 5, repeated: true, type: SBoM.CycloneDX.V16.Property)
  field(:resourceReferences, 6, repeated: true, type: SBoM.CycloneDX.V16.ResourceReferenceChoice)
  field(:taskTypes, 7, repeated: true, type: SBoM.CycloneDX.V16.TaskType, enum: true)
  field(:trigger, 8, proto3_optional: true, type: SBoM.CycloneDX.V16.Trigger)
  field(:steps, 9, repeated: true, type: SBoM.CycloneDX.V16.Step)
  field(:inputs, 10, repeated: true, type: SBoM.CycloneDX.V16.InputType)
  field(:outputs, 11, repeated: true, type: SBoM.CycloneDX.V16.OutputType)
  field(:timeStart, 14, proto3_optional: true, type: Timestamp)
  field(:timeEnd, 15, proto3_optional: true, type: Timestamp)
  field(:workspaces, 16, repeated: true, type: SBoM.CycloneDX.V16.Workspace)
  field(:runtimeTopology, 17, repeated: true, type: SBoM.CycloneDX.V16.Dependency)
end
