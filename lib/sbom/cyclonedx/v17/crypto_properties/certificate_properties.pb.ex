defmodule SBoM.CycloneDX.V17.CryptoProperties.CertificateProperties do
  @moduledoc """
  Certificate Properties
  """

  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  alias Google.Protobuf.Timestamp

  field(:serialNumber, 9, proto3_optional: true, type: :string)
  field(:subjectName, 1, proto3_optional: true, type: :string)
  field(:issuerName, 2, proto3_optional: true, type: :string)
  field(:notValidBefore, 3, proto3_optional: true, type: Timestamp)
  field(:notValidAfter, 4, proto3_optional: true, type: Timestamp)
  field(:signatureAlgorithmRef, 5, proto3_optional: true, type: :string, deprecated: true)
  field(:subjectPublicKeyRef, 6, proto3_optional: true, type: :string, deprecated: true)
  field(:certificateFormat, 7, proto3_optional: true, type: :string)
  field(:certificateExtension, 8, proto3_optional: true, type: :string, deprecated: true)
  field(:certificateFileExtension, 10, proto3_optional: true, type: :string)
  field(:fingerprint, 11, proto3_optional: true, type: SBoM.CycloneDX.V17.Hash)

  field(:certificateState, 12,
    repeated: true,
    type: SBoM.CycloneDX.V17.CryptoProperties.CertificateState
  )

  field(:creationDate, 13, proto3_optional: true, type: Timestamp)
  field(:activationDate, 14, proto3_optional: true, type: Timestamp)
  field(:deactivationDate, 15, proto3_optional: true, type: Timestamp)
  field(:revocationDate, 16, proto3_optional: true, type: Timestamp)
  field(:destructionDate, 17, proto3_optional: true, type: Timestamp)

  field(:certificateExtensions, 18,
    proto3_optional: true,
    type: SBoM.CycloneDX.V17.CryptoProperties.CertificateExtensions
  )

  field(:relatedCryptographicAssets, 19,
    proto3_optional: true,
    type: SBoM.CycloneDX.V17.CryptoProperties.RelatedCryptographicAssets
  )
end
