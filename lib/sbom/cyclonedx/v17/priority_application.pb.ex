defmodule SBoM.Cyclonedx.V17.PriorityApplication do
  @moduledoc false

  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field(:application_number, 1, type: :string, json_name: "applicationNumber")
  field(:jurisdiction, 2, type: :string)
  field(:filing_date, 3, type: Google.Protobuf.Timestamp, json_name: "filingDate")
end
