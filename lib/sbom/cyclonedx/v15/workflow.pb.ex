defmodule SBoM.CycloneDX.V15.Workflow do
  @moduledoc """
  A specialized orchestration task.
  """

  use Protobuf,
    full_name: "cyclonedx.v1_5.Workflow",
    protoc_gen_elixir_version: "0.16.0",
    syntax: :proto3

  alias Google.Protobuf.Timestamp
  alias SBoM.CycloneDX.V15.Dependency

  field(:bom_ref, 1, type: :string, json_name: "bomRef")
  field(:uid, 2, type: :string)
  field(:name, 3, proto3_optional: true, type: :string)
  field(:description, 4, proto3_optional: true, type: :string)
  field(:properties, 5, repeated: true, type: SBoM.CycloneDX.V15.Property)
  field(:resourceReferences, 6, repeated: true, type: SBoM.CycloneDX.V15.ResourceReferenceChoice)
  field(:tasks, 7, repeated: true, type: SBoM.CycloneDX.V15.Task)
  field(:taskDependencies, 8, repeated: true, type: Dependency)
  field(:taskTypes, 9, repeated: true, type: SBoM.CycloneDX.V15.TaskType, enum: true)
  field(:trigger, 10, proto3_optional: true, type: SBoM.CycloneDX.V15.Trigger)
  field(:steps, 11, repeated: true, type: SBoM.CycloneDX.V15.Step)
  field(:inputs, 12, repeated: true, type: SBoM.CycloneDX.V15.InputType)
  field(:outputs, 13, repeated: true, type: SBoM.CycloneDX.V15.OutputType)
  field(:timeStart, 14, proto3_optional: true, type: Timestamp)
  field(:timeEnd, 15, proto3_optional: true, type: Timestamp)
  field(:workspaces, 16, repeated: true, type: SBoM.CycloneDX.V15.Workspace)
  field(:runtimeTopology, 17, repeated: true, type: Dependency)
end
