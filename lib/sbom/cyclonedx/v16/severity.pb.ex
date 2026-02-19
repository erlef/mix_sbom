defmodule SBoM.CycloneDX.V16.Severity do
  @moduledoc """
  Textual representation of the severity of the vulnerability adopted by the analysis method. If the analysis method uses values other than what is provided, the user is expected to translate appropriately.
  """

  use Protobuf,
    enum: true,
    full_name: "cyclonedx.v1_6.Severity",
    protoc_gen_elixir_version: "0.16.0",
    syntax: :proto3

  field(:SEVERITY_UNKNOWN, 0)
  field(:SEVERITY_CRITICAL, 1)
  field(:SEVERITY_HIGH, 2)
  field(:SEVERITY_MEDIUM, 3)
  field(:SEVERITY_LOW, 4)
  field(:SEVERITY_INFO, 5)
  field(:SEVERITY_NONE, 6)
end
