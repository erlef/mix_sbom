defmodule SBoM.CycloneDX.V16.Dependency do
  @moduledoc """
  Defines the direct dependencies of a component, service, or the components provided/implemented by a given component. Components or services that do not have their own dependencies must be declared as empty elements within the graph. Components or services that are not represented in the dependency graph may have unknown dependencies. It is recommended that implementations assume this to be opaque and not an indicator of an object being dependency-free. It is recommended to leverage compositions to indicate unknown dependency graphs.
  """

  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field(:ref, 1, type: :string)
  field(:dependencies, 2, repeated: true, type: SBoM.CycloneDX.V16.Dependency)
  field(:provides, 3, repeated: true, type: :string)
end
