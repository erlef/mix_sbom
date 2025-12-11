defmodule SBoM.CycloneDX.V17.PatentLegalStatus do
  @moduledoc """
  Indicates the current legal status of the patent or patent application, based on the WIPO ST.27 standard. This status reflects administrative, procedural, or legal events. Values include both active and inactive states and are useful for determining enforceability, procedural history, and maintenance status.
  """

  use Protobuf, enum: true, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field(:PATENT_LEGAL_STATUS_UNSPECIFIED, 0)
  field(:PATENT_LEGAL_STATUS_PENDING, 1)
  field(:PATENT_LEGAL_STATUS_GRANTED, 2)
  field(:PATENT_LEGAL_STATUS_REVOKED, 3)
  field(:PATENT_LEGAL_STATUS_EXPIRED, 4)
  field(:PATENT_LEGAL_STATUS_LAPSED, 5)
  field(:PATENT_LEGAL_STATUS_WITHDRAWN, 6)
  field(:PATENT_LEGAL_STATUS_ABANDONED, 7)
  field(:PATENT_LEGAL_STATUS_SUSPENDED, 8)
  field(:PATENT_LEGAL_STATUS_REINSTATED, 9)
  field(:PATENT_LEGAL_STATUS_OPPOSED, 10)
  field(:PATENT_LEGAL_STATUS_TERMINATED, 11)
  field(:PATENT_LEGAL_STATUS_INVALIDATED, 12)
  field(:PATENT_LEGAL_STATUS_IN_FORCE, 13)
end
