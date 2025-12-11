defmodule SBoM.CycloneDX.V13.HashAlg do
  @moduledoc "CycloneDX HashAlg model."
  use Protobuf, enum: true, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field(:HASH_ALG_NULL, 0)
  field(:HASH_ALG_MD_5, 1)
  field(:HASH_ALG_SHA_1, 2)
  field(:HASH_ALG_SHA_256, 3)
  field(:HASH_ALG_SHA_384, 4)
  field(:HASH_ALG_SHA_512, 5)
  field(:HASH_ALG_SHA_3_256, 6)
  field(:HASH_ALG_SHA_3_384, 7)
  field(:HASH_ALG_SHA_3_512, 8)
  field(:HASH_ALG_BLAKE_2_B_256, 9)
  field(:HASH_ALG_BLAKE_2_B_384, 10)
  field(:HASH_ALG_BLAKE_2_B_512, 11)
  field(:HASH_ALG_BLAKE_3, 12)
end
