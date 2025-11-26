# SPDX-License-Identifier: BSD-3-Clause
# SPDX-FileCopyrightText: 2025 Erlang Ecosystem Foundation

defprotocol SBoM.CycloneDX.JSON.Encodable do
  @moduledoc """
  Protocol for converting CycloneDX structs to JSON-encodable data structures.

  This protocol provides custom control over JSON encoding while maintaining
  compatibility with Protobuf's built-in JSON encoding for generated structs.
  """

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

  @impl SBoM.CycloneDX.JSON.Encodable
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
  @impl SBoM.CycloneDX.JSON.Encodable
  def to_encodable(struct) do
    {:ok, encoded} = Protobuf.JSON.to_encodable(struct, [])
    encoded
  end
end

defimpl SBoM.CycloneDX.JSON.Encodable,
  for: [
    SBoM.Cyclonedx.V17.Component,
    SBoM.Cyclonedx.V16.Component,
    SBoM.Cyclonedx.V15.Component,
    SBoM.Cyclonedx.V14.Component,
    SBoM.Cyclonedx.V13.Component
  ] do
  alias SBoM.CycloneDX.JSON.Encoder

  @type classification() ::
          SBoM.Cyclonedx.V13.Classification.t()
          | SBoM.Cyclonedx.V14.Classification.t()
          | SBoM.Cyclonedx.V15.Classification.t()
          | SBoM.Cyclonedx.V16.Classification.t()
          | SBoM.Cyclonedx.V17.Classification.t()
  @type scope() ::
          SBoM.Cyclonedx.V13.Scope.t()
          | SBoM.Cyclonedx.V14.Scope.t()
          | SBoM.Cyclonedx.V15.Scope.t()
          | SBoM.Cyclonedx.V16.Scope.t()
          | SBoM.Cyclonedx.V17.Scope.t()

  @impl SBoM.CycloneDX.JSON.Encodable
  def to_encodable(component) do
    component
    |> Encoder.encodable()
    |> Map.update("type", nil, &classification_to_string/1)
    |> Map.update("scope", nil, &scope_to_string/1)
    |> rename_bom_ref()
  end

  @spec rename_bom_ref(map()) :: map()
  defp rename_bom_ref(map) do
    case Map.pop(map, "bomRef") do
      {nil, map} -> map
      {bom_ref, map} -> Map.put(map, "bom-ref", bom_ref)
    end
  end

  @spec classification_to_string(classification()) :: String.t() | nil
  defp classification_to_string(:CLASSIFICATION_NULL), do: nil
  defp classification_to_string(:CLASSIFICATION_APPLICATION), do: "application"
  defp classification_to_string(:CLASSIFICATION_FRAMEWORK), do: "framework"
  defp classification_to_string(:CLASSIFICATION_LIBRARY), do: "library"
  defp classification_to_string(:CLASSIFICATION_OPERATING_SYSTEM), do: "operating-system"
  defp classification_to_string(:CLASSIFICATION_DEVICE), do: "device"
  defp classification_to_string(:CLASSIFICATION_FILE), do: "file"
  defp classification_to_string(:CLASSIFICATION_CONTAINER), do: "container"
  defp classification_to_string(:CLASSIFICATION_FIRMWARE), do: "firmware"
  defp classification_to_string(:CLASSIFICATION_DEVICE_DRIVER), do: "device-driver"
  defp classification_to_string(:CLASSIFICATION_PLATFORM), do: "platform"

  defp classification_to_string(:CLASSIFICATION_MACHINE_LEARNING_MODEL), do: "machine-learning-model"

  defp classification_to_string(:CLASSIFICATION_DATA), do: "data"
  defp classification_to_string(:CLASSIFICATION_CRYPTOGRAPHIC_ASSET), do: "cryptographic-asset"

  @spec scope_to_string(scope() | nil) :: String.t() | nil
  defp scope_to_string(:SCOPE_UNSPECIFIED), do: nil
  defp scope_to_string(:SCOPE_REQUIRED), do: "required"
  defp scope_to_string(:SCOPE_OPTIONAL), do: "optional"
  defp scope_to_string(:SCOPE_EXCLUDED), do: "excluded"
  defp scope_to_string(nil), do: nil
end

defimpl SBoM.CycloneDX.JSON.Encodable,
  for: [
    SBoM.Cyclonedx.V17.Dependency,
    SBoM.Cyclonedx.V16.Dependency,
    SBoM.Cyclonedx.V15.Dependency,
    SBoM.Cyclonedx.V14.Dependency,
    SBoM.Cyclonedx.V13.Dependency
  ] do
  alias SBoM.CycloneDX.JSON.Encoder

  @impl SBoM.CycloneDX.JSON.Encodable
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
    SBoM.Cyclonedx.V17.Bom,
    SBoM.Cyclonedx.V16.Bom,
    SBoM.Cyclonedx.V15.Bom,
    SBoM.Cyclonedx.V14.Bom,
    SBoM.Cyclonedx.V13.Bom
  ] do
  alias SBoM.CycloneDX.JSON.Encoder

  @impl SBoM.CycloneDX.JSON.Encodable
  def to_encodable(bom) do
    encoded = Encoder.encodable(bom)
    Map.put(encoded, "bomFormat", "CycloneDX")
  end
end
