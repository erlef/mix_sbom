defmodule SBoM.CycloneDX.V14.ScoreMethod do
  @moduledoc "CycloneDX ScoreMethod model."
  use Protobuf, enum: true, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field(:SCORE_METHOD_NULL, 0)
  field(:SCORE_METHOD_CVSSV2, 1)
  field(:SCORE_METHOD_CVSSV3, 2)
  field(:SCORE_METHOD_CVSSV31, 3)
  field(:SCORE_METHOD_OWASP, 4)
  field(:SCORE_METHOD_OTHER, 5)
end
