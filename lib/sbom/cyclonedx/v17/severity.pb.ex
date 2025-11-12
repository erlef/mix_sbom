defmodule SBoM.Cyclonedx.V17.Severity do
  @moduledoc false

  use Protobuf, enum: true, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field(:SEVERITY_UNKNOWN, 0)
  field(:SEVERITY_CRITICAL, 1)
  field(:SEVERITY_HIGH, 2)
  field(:SEVERITY_MEDIUM, 3)
  field(:SEVERITY_LOW, 4)
  field(:SEVERITY_INFO, 5)
  field(:SEVERITY_NONE, 6)
end
