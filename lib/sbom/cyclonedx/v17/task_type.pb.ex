defmodule SBoM.Cyclonedx.V17.TaskType do
  @moduledoc false

  use Protobuf, enum: true, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field(:TASK_TYPE_COPY, 0)
  field(:TASK_TYPE_CLONE, 1)
  field(:TASK_TYPE_LINT, 2)
  field(:TASK_TYPE_SCAN, 3)
  field(:TASK_TYPE_MERGE, 4)
  field(:TASK_TYPE_BUILD, 5)
  field(:TASK_TYPE_TEST, 6)
  field(:TASK_TYPE_DELIVER, 7)
  field(:TASK_TYPE_DEPLOY, 8)
  field(:TASK_TYPE_RELEASE, 9)
  field(:TASK_TYPE_CLEAN, 10)
  field(:TASK_TYPE_OTHER, 11)
end
