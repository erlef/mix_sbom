defmodule SBoM.CycloneDX.V16.CryptoProperties.CertificateProperties do
  @moduledoc """
  Certificate Properties
  """

  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  alias Google.Protobuf.Timestamp

  field(:subjectName, 1, proto3_optional: true, type: :string)
  field(:issuerName, 2, proto3_optional: true, type: :string)
  field(:notValidBefore, 3, proto3_optional: true, type: Timestamp)
  field(:notValidAfter, 4, proto3_optional: true, type: Timestamp)
  field(:signatureAlgorithmRef, 5, proto3_optional: true, type: :string)
  field(:subjectPublicKeyRef, 6, proto3_optional: true, type: :string)
  field(:certificateFormat, 7, proto3_optional: true, type: :string)
  field(:certificateExtension, 8, proto3_optional: true, type: :string)
end
