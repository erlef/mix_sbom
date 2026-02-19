defmodule SBoM.CycloneDX.V17.TlpClassification do
  @moduledoc """
  Traffic Light Protocol (TLP) is a classification system for identifying the potential risk associated with artefact, including whether it is subject to certain types of legal, financial, or technical threats. Refer to https://www.first.org/tlp/ for further information.
  The default classification is "CLEAR"
  """

  use Protobuf,
    enum: true,
    full_name: "cyclonedx.v1_7.TlpClassification",
    protoc_gen_elixir_version: "0.16.0",
    syntax: :proto3

  field(:TLP_CLASSIFICATION_CLEAR, 0)
  field(:TLP_CLASSIFICATION_GREEN, 1)
  field(:TLP_CLASSIFICATION_AMBER, 2)
  field(:TLP_CLASSIFICATION_AMBER_AND_STRICT, 3)
  field(:TLP_CLASSIFICATION_RED, 4)
end
