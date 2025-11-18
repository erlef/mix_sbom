defmodule SBoM.Cyclonedx.V14.PatchClassification do
  @moduledoc false

  use Protobuf, enum: true, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field(:PATCH_CLASSIFICATION_NULL, 0)
  field(:PATCH_CLASSIFICATION_UNOFFICIAL, 1)
  field(:PATCH_CLASSIFICATION_MONKEY, 2)
  field(:PATCH_CLASSIFICATION_BACKPORT, 3)
  field(:PATCH_CLASSIFICATION_CHERRY_PICK, 4)
end
