defmodule SBoM.CycloneDX.V17.PriorityApplication do
  @moduledoc """
  The priorityApplication contains the essential data necessary to identify and reference an earlier patent filing for priority rights. In line with WIPO ST.96 guidelines, it includes the jurisdiction (office code), application number, and filing date-the three key elements that uniquely specify the priority application in a global patent context.
  """

  use Protobuf,
    full_name: "cyclonedx.v1_7.PriorityApplication",
    protoc_gen_elixir_version: "0.16.0",
    syntax: :proto3

  field(:application_number, 1, type: :string, json_name: "applicationNumber")
  field(:jurisdiction, 2, type: :string)
  field(:filing_date, 3, type: Google.Protobuf.Timestamp, json_name: "filingDate")
end
