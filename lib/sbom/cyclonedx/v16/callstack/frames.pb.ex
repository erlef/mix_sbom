defmodule SBoM.Cyclonedx.V16.Callstack.Frames do
  @moduledoc false

  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field(:package, 1, proto3_optional: true, type: :string)
  field(:module, 2, type: :string)
  field(:function, 3, proto3_optional: true, type: :string)
  field(:parameters, 4, repeated: true, type: :string)
  field(:line, 5, proto3_optional: true, type: :int32)
  field(:column, 6, proto3_optional: true, type: :int32)
  field(:fullFilename, 7, proto3_optional: true, type: :string)
end
