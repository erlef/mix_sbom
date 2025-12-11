# SPDX-License-Identifier: BSD-3-Clause
# SPDX-FileCopyrightText: 2025 Erlang Ecosystem Foundation

alias SBoM.CycloneDX.JSON.Encodable

defprotocol SBoM.CycloneDX.JSON.Encodable do
  @moduledoc false

  # Protocol for converting CycloneDX structs to JSON-encodable data structures.
  #
  # This protocol provides custom control over JSON encoding while maintaining
  # compatibility with Protobuf's built-in JSON encoding for generated structs.

  @fallback_to_any true

  @doc """
  Converts a struct to a JSON-encodable data structure.

  Returns a map or other JSON-compatible data structure that can be passed
  to `Jason.encode/1` or similar JSON encoding functions.
  """
  @spec to_encodable(t()) :: map() | list() | binary() | number() | boolean() | nil
  def to_encodable(data)
end

defimpl SBoM.CycloneDX.JSON.Encodable, for: Any do
  alias SBoM.CycloneDX.JSON.Encoder

  @impl Encodable
  def to_encodable(%module{} = struct) do
    true = function_exported?(module, :__message_props__, 0)
    Encoder.encodable(struct)
  end
end

defimpl SBoM.CycloneDX.JSON.Encodable,
  for: [
    Google.Protobuf.FieldMask,
    Google.Protobuf.Duration,
    Google.Protobuf.Timestamp,
    Google.Protobuf.BytesValue,
    Google.Protobuf.Struct,
    Google.Protobuf.ListValue,
    Google.Protobuf.Value,
    Google.Protobuf.Empty,
    Google.Protobuf.Int32Value,
    Google.Protobuf.UInt32Value,
    Google.Protobuf.UInt64Value,
    Google.Protobuf.Int64Value,
    Google.Protobuf.FloatValue,
    Google.Protobuf.DoubleValue,
    Google.Protobuf.BoolValue,
    Google.Protobuf.StringValue,
    Google.Protobuf.Any
  ] do
  @impl Encodable
  def to_encodable(struct) do
    {:ok, encoded} = Protobuf.JSON.to_encodable(struct, [])
    encoded
  end
end

defimpl SBoM.CycloneDX.JSON.Encodable,
  for: [
    SBoM.CycloneDX.V17.Component,
    SBoM.CycloneDX.V16.Component,
    SBoM.CycloneDX.V15.Component,
    SBoM.CycloneDX.V14.Component,
    SBoM.CycloneDX.V13.Component
  ] do
  alias SBoM.CycloneDX.Common.EnumHelpers
  alias SBoM.CycloneDX.JSON.Encoder

  @impl Encodable
  def to_encodable(component) do
    component
    |> Encoder.encodable()
    |> Map.update("type", nil, &EnumHelpers.classification_to_string/1)
    |> Map.update("scope", nil, &EnumHelpers.scope_to_string/1)
    |> rename_bom_ref()
  end

  @spec rename_bom_ref(map()) :: map()
  defp rename_bom_ref(map) do
    case Map.pop(map, "bomRef") do
      {nil, map} -> map
      {bom_ref, map} -> Map.put(map, "bom-ref", bom_ref)
    end
  end
end

defimpl SBoM.CycloneDX.JSON.Encodable,
  for: [
    SBoM.CycloneDX.V17.Hash,
    SBoM.CycloneDX.V16.Hash,
    SBoM.CycloneDX.V15.Hash,
    SBoM.CycloneDX.V14.Hash,
    SBoM.CycloneDX.V13.Hash
  ] do
  alias SBoM.CycloneDX.Common.EnumHelpers
  alias SBoM.CycloneDX.JSON.Encoder

  @impl Encodable
  def to_encodable(hash) do
    hash
    |> Encoder.encodable()
    |> Map.update("alg", nil, &EnumHelpers.hash_alg_to_string/1)
    |> rename_value_to_content()
  end

  @spec rename_value_to_content(map()) :: map()
  defp rename_value_to_content(map) do
    case Map.pop(map, "value") do
      {nil, map} -> map
      {value, map} -> Map.put(map, "content", value)
    end
  end
end

defimpl SBoM.CycloneDX.JSON.Encodable,
  for: [
    SBoM.CycloneDX.V17.ExternalReference,
    SBoM.CycloneDX.V16.ExternalReference,
    SBoM.CycloneDX.V15.ExternalReference,
    SBoM.CycloneDX.V14.ExternalReference,
    SBoM.CycloneDX.V13.ExternalReference
  ] do
  alias SBoM.CycloneDX.Common.EnumHelpers
  alias SBoM.CycloneDX.JSON.Encoder

  @impl Encodable
  def to_encodable(external_reference) do
    external_reference
    |> Encoder.encodable()
    |> Map.update("type", nil, &EnumHelpers.external_reference_type_to_string/1)
  end
end

defimpl SBoM.CycloneDX.JSON.Encodable,
  for: [
    SBoM.CycloneDX.V17.Dependency,
    SBoM.CycloneDX.V16.Dependency,
    SBoM.CycloneDX.V15.Dependency,
    SBoM.CycloneDX.V14.Dependency,
    SBoM.CycloneDX.V13.Dependency
  ] do
  alias SBoM.CycloneDX.JSON.Encoder

  @impl Encodable
  def to_encodable(dependency) do
    dependency
    |> Encoder.encodable()
    |> rename_dependencies_to_depends_on()
  end

  @spec rename_dependencies_to_depends_on(map()) :: map()
  defp rename_dependencies_to_depends_on(map) do
    case Map.pop(map, "dependencies") do
      {nil, map} ->
        map

      {[], map} ->
        map

      {dependencies, map} ->
        depends_on = Enum.map(dependencies, fn %{"ref" => ref} -> ref end)
        Map.put(map, "dependsOn", depends_on)
    end
  end
end

defimpl SBoM.CycloneDX.JSON.Encodable,
  for: [
    SBoM.CycloneDX.V17.Bom,
    SBoM.CycloneDX.V16.Bom,
    SBoM.CycloneDX.V15.Bom,
    SBoM.CycloneDX.V14.Bom,
    SBoM.CycloneDX.V13.Bom
  ] do
  alias SBoM.CycloneDX.JSON.Encoder

  @impl Encodable
  def to_encodable(bom) do
    encoded = Encoder.encodable(bom)
    Map.put(encoded, "bomFormat", "CycloneDX")
  end
end
