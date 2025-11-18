defmodule SBoM.Cyclonedx.V16.ModelCard.ModelCardConsiderations.EnergyConsumption.ActivityType do
  @moduledoc false

  use Protobuf, enum: true, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field(:ACTIVITY_TYPE_UNSPECIFIED, 0)
  field(:ACTIVITY_TYPE_OTHER, 1)
  field(:ACTIVITY_TYPE_DESIGN, 2)
  field(:ACTIVITY_TYPE_DATA_COLLECTION, 3)
  field(:ACTIVITY_TYPE_DATA_PREPARATION, 4)
  field(:ACTIVITY_TYPE_TRAINING, 5)
  field(:ACTIVITY_TYPE_FINE_TUNING, 6)
  field(:ACTIVITY_TYPE_VALIDATION, 7)
  field(:ACTIVITY_TYPE_DEPLOYMENT, 8)
  field(:ACTIVITY_TYPE_INFERENCE, 9)
end
