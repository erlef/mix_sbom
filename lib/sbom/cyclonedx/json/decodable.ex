# SPDX-License-Identifier: BSD-3-Clause
# SPDX-FileCopyrightText: 2025 Erlang Ecosystem Foundation

alias Google.Protobuf.Value
alias SBoM.CycloneDX.JSON.Decodable

defprotocol SBoM.CycloneDX.JSON.Decodable do
  @moduledoc false

  # Protocol for converting JSON data to CycloneDX structs.
  #
  # This protocol provides custom control over JSON decoding while maintaining
  # compatibility with Protobuf's built-in JSON decoding for generated structs.

  @fallback_to_any true

  @type json_data() ::
          %{String.t() => json_data()}
          | list(json_data())
          | String.t()
          | number()
          | boolean()
          | float()
          | nil

  @doc """
  Converts JSON data to a struct.

  Takes an empty struct for protocol dispatch and a map of JSON data,
  returns a fully populated struct.
  """
  @spec from_json_data(struct(), json_data()) :: struct()
  def from_json_data(empty_struct, json_data)
end

defimpl SBoM.CycloneDX.JSON.Decodable, for: Any do
  alias SBoM.CycloneDX.JSON.Decoder

  @impl Decodable
  def from_json_data(%module{} = struct, data) when is_map(data) and is_atom(module) do
    if function_exported?(module, :__message_props__, 0) do
      Decoder.decode_struct(struct, data)
    else
      throw({:bad_message, data, module})
    end
  end
end

defimpl SBoM.CycloneDX.JSON.Decodable, for: Google.Protobuf.Duration do
  alias Protobuf.JSON.Utils
  alias SBoM.CycloneDX.JSON.Decoder

  @duration_seconds_range -315_576_000_000..315_576_000_000

  @impl Decodable
  def from_json_data(struct, string) when is_binary(string) do
    # We need to check the sign from the raw string itself and can't rely on Integer.parse/1. This
    # is because if seconds is 0, then we couldn't determine whether it was "0" or "-0". For
    # example, "-0.5s".
    sign = if String.starts_with?(string, "-"), do: -1, else: 1

    case Integer.parse(string) do
      {seconds, "s"} when seconds in @duration_seconds_range ->
        struct!(struct, seconds: seconds)

      {seconds, "." <> nanos_with_s} when seconds in @duration_seconds_range ->
        case Utils.parse_nanoseconds(nanos_with_s) do
          {nanos, "s"} -> struct!(struct, seconds: seconds, nanos: nanos * sign)
          :error -> throw({:bad_duration, string, nanos_with_s})
        end

      other ->
        throw({:bad_duration, string, other})
    end
  end
end

defimpl SBoM.CycloneDX.JSON.Decodable, for: Google.Protobuf.Timestamp do
  @impl Decodable
  def from_json_data(struct, string) when is_binary(string) do
    case Protobuf.JSON.RFC3339.decode(string) do
      {:ok, seconds, nanos} -> struct!(struct, seconds: seconds, nanos: nanos)
      {:error, reason} -> throw({:bad_timestamp, string, reason})
    end
  end
end

defimpl SBoM.CycloneDX.JSON.Decodable, for: Google.Protobuf.Empty do
  @impl Decodable
  def from_json_data(struct, map) when map == %{} do
    struct
  end
end

defimpl SBoM.CycloneDX.JSON.Decodable, for: Google.Protobuf.Int32Value do
  alias SBoM.CycloneDX.JSON.Decoder

  @impl Decodable
  def from_json_data(struct, int) do
    struct!(struct, value: Decoder.decode_scalar(:int32, :unknown_name, int))
  end
end

defimpl SBoM.CycloneDX.JSON.Decodable, for: Google.Protobuf.UInt32Value do
  alias SBoM.CycloneDX.JSON.Decoder

  @impl Decodable
  def from_json_data(struct, int) do
    struct!(struct, value: Decoder.decode_scalar(:uint32, :unknown_name, int))
  end
end

defimpl SBoM.CycloneDX.JSON.Decodable, for: Google.Protobuf.UInt64Value do
  alias SBoM.CycloneDX.JSON.Decoder

  @impl Decodable
  def from_json_data(struct, int) do
    struct!(struct, value: Decoder.decode_scalar(:uint64, :unknown_name, int))
  end
end

defimpl SBoM.CycloneDX.JSON.Decodable, for: Google.Protobuf.Int64Value do
  alias SBoM.CycloneDX.JSON.Decoder

  @impl Decodable
  def from_json_data(struct, int) do
    struct!(struct, value: Decoder.decode_scalar(:int64, :unknown_name, int))
  end
end

defimpl SBoM.CycloneDX.JSON.Decodable, for: Google.Protobuf.FloatValue do
  @impl Decodable
  def from_json_data(struct, number) when is_float(number) or is_integer(number) do
    struct!(struct, value: number * 1.0)
  end
end

defimpl SBoM.CycloneDX.JSON.Decodable, for: Google.Protobuf.DoubleValue do
  @impl Decodable
  def from_json_data(struct, number) when is_float(number) or is_integer(number) do
    struct!(struct, value: number * 1.0)
  end
end

defimpl SBoM.CycloneDX.JSON.Decodable, for: Google.Protobuf.BoolValue do
  alias SBoM.CycloneDX.JSON.Decoder

  @impl Decodable
  def from_json_data(struct, bool) when is_boolean(bool) do
    struct!(struct, value: Decoder.decode_scalar(:bool, :unknown_field, bool))
  end
end

defimpl SBoM.CycloneDX.JSON.Decodable, for: Google.Protobuf.StringValue do
  alias SBoM.CycloneDX.JSON.Decoder

  @impl Decodable
  def from_json_data(struct, string) when is_binary(string) do
    struct!(struct, value: Decoder.decode_scalar(:string, :unknown_field, string))
  end
end

defimpl SBoM.CycloneDX.JSON.Decodable, for: Google.Protobuf.BytesValue do
  alias SBoM.CycloneDX.JSON.Decoder

  @impl Decodable
  def from_json_data(struct, bytes) when is_binary(bytes) do
    struct!(struct, value: Decoder.decode_scalar(:bytes, :unknown_field, bytes))
  end
end

defimpl SBoM.CycloneDX.JSON.Decodable, for: Google.Protobuf.ListValue do
  @impl Decodable
  def from_json_data(struct, list) when is_list(list) do
    struct!(struct,
      values: Enum.map(list, &Decodable.from_json_data(%Value{}, &1))
    )
  end
end

defimpl SBoM.CycloneDX.JSON.Decodable, for: Google.Protobuf.Struct do
  @impl Decodable
  def from_json_data(struct, struct_data) when is_map(struct_data) do
    fields =
      Map.new(struct_data, fn {key, val} ->
        {key, Decodable.from_json_data(%Value{}, val)}
      end)

    struct!(struct, fields: fields)
  end
end

defimpl SBoM.CycloneDX.JSON.Decodable, for: Google.Protobuf.Value do
  @impl Decodable
  def from_json_data(struct, term) do
    cond do
      is_nil(term) ->
        struct!(struct, kind: {:null_value, :NULL_VALUE})

      is_binary(term) ->
        struct!(struct, kind: {:string_value, term})

      is_integer(term) ->
        struct!(struct, kind: {:number_value, term * 1.0})

      is_float(term) ->
        struct!(struct, kind: {:number_value, term})

      is_boolean(term) ->
        struct!(struct, kind: {:bool_value, term})

      is_list(term) ->
        struct!(struct,
          kind: {:list_value, Decodable.from_json_data(%Google.Protobuf.ListValue{}, term)}
        )

      is_map(term) ->
        struct!(struct,
          kind: {:struct_value, Decodable.from_json_data(%Google.Protobuf.Struct{}, term)}
        )

      true ->
        throw({:bad_message, term, struct})
    end
  end
end

defimpl SBoM.CycloneDX.JSON.Decodable, for: Google.Protobuf.FieldMask do
  alias SBoM.CycloneDX.JSON.Decoder

  @impl Decodable
  def from_json_data(struct, data) when is_binary(data) do
    paths = String.split(data, ",")

    cond do
      data == "" ->
        struct!(struct, paths: [])

      paths = Enum.map(paths, &convert_field_mask_to_underscore/1) ->
        struct!(struct, paths: paths)

      true ->
        throw({:bad_field_mask, data})
    end
  end

  @spec convert_field_mask_to_underscore(String.t()) :: String.t()
  def convert_field_mask_to_underscore(mask) do
    if mask =~ ~r/^[a-zA-Z0-9\.]+$/ do
      mask
      |> String.split(".")
      |> Enum.map_join(".", &Macro.underscore/1)
    else
      throw({:bad_field_mask, mask})
    end
  end
end

defimpl SBoM.CycloneDX.JSON.Decodable, for: Google.Protobuf.Any do
  @impl Decodable
  def from_json_data(struct, %{"@type" => type_url} = data) do
    data = Map.delete(data, "@type")
    message_mod = Protobuf.Any.type_url_to_module(type_url)

    encoded =
      case Map.fetch(data, "value") do
        # Types with a built-in JSON representation (like google.protobuf.Timestamp) have a
        # "value" field with the JSON representation itself.
        # See: https://developers.google.com/protocol-buffers/docs/proto3#json
        {:ok, value} ->
          message_mod
          |> struct()
          |> Decodable.from_json_data(value)
          |> message_mod.encode()

        # When a message doesn't have a built-in JSON representation (like
        # google.protobuf.Timestamp), then it's encoded as a JSON object and then a @type field is
        # added with the type_url for that message.
        :error ->
          message_mod
          |> struct()
          |> Decodable.from_json_data(data)
          |> message_mod.encode()
      end

    struct!(struct, type_url: type_url, value: encoded)
  end
end

defimpl SBoM.CycloneDX.JSON.Decodable,
  for: [
    SBoM.Cyclonedx.V17.Component,
    SBoM.Cyclonedx.V16.Component,
    SBoM.Cyclonedx.V15.Component,
    SBoM.Cyclonedx.V14.Component,
    SBoM.Cyclonedx.V13.Component
  ] do
  alias SBoM.CycloneDX.Common.EnumHelpers
  alias SBoM.CycloneDX.JSON.Decoder

  @impl Decodable
  def from_json_data(struct, data) when is_map(data) do
    data =
      data
      |> transform_bom_ref()
      |> transform_type_field()
      |> transform_scope_field()

    Decoder.decode_struct(struct, data)
  end

  @spec transform_bom_ref(map()) :: map()
  defp transform_bom_ref(data) do
    case Map.pop(data, "bom-ref") do
      {nil, data} -> data
      {bom_ref, data} -> Map.put(data, "bomRef", bom_ref)
    end
  end

  @spec transform_type_field(map()) :: map()
  defp transform_type_field(data) do
    Map.update(data, "type", "CLASSIFICATION_NULL", fn type_string ->
      case EnumHelpers.string_to_classification(type_string) do
        nil -> "CLASSIFICATION_NULL"
        enum_value -> Atom.to_string(enum_value)
      end
    end)
  end

  @spec transform_scope_field(map()) :: map()
  defp transform_scope_field(data) do
    Map.update(data, "scope", "SCOPE_UNSPECIFIED", fn scope_string ->
      case EnumHelpers.string_to_scope(scope_string) do
        nil -> "SCOPE_UNSPECIFIED"
        enum_value -> Atom.to_string(enum_value)
      end
    end)
  end
end

defimpl SBoM.CycloneDX.JSON.Decodable,
  for: [
    SBoM.Cyclonedx.V17.Hash,
    SBoM.Cyclonedx.V16.Hash,
    SBoM.Cyclonedx.V15.Hash,
    SBoM.Cyclonedx.V14.Hash,
    SBoM.Cyclonedx.V13.Hash
  ] do
  alias SBoM.CycloneDX.Common.EnumHelpers
  alias SBoM.CycloneDX.JSON.Decoder

  @impl Decodable
  def from_json_data(%{} = struct, data) when is_map(data) do
    data =
      data
      |> transform_content_to_value()
      |> transform_alg_field()

    Decoder.decode_struct(struct, data)
  end

  @spec transform_content_to_value(map()) :: map()
  defp transform_content_to_value(data) do
    case Map.pop(data, "content") do
      {nil, data} -> data
      {content, data} -> Map.put(data, "value", content)
    end
  end

  @spec transform_alg_field(map()) :: map()
  defp transform_alg_field(data) do
    Map.update(data, "alg", "HASH_ALG_NULL", fn alg_string ->
      case EnumHelpers.string_to_hash_alg(alg_string) do
        nil -> "HASH_ALG_NULL"
        enum_value -> Atom.to_string(enum_value)
      end
    end)
  end
end

defimpl SBoM.CycloneDX.JSON.Decodable,
  for: [
    SBoM.Cyclonedx.V17.ExternalReference,
    SBoM.Cyclonedx.V16.ExternalReference,
    SBoM.Cyclonedx.V15.ExternalReference,
    SBoM.Cyclonedx.V14.ExternalReference,
    SBoM.Cyclonedx.V13.ExternalReference
  ] do
  alias SBoM.CycloneDX.Common.EnumHelpers
  alias SBoM.CycloneDX.JSON.Decoder

  @impl Decodable
  def from_json_data(%{} = struct, data) when is_map(data) do
    data = transform_type_field(data)

    Decoder.decode_struct(struct, data)
  end

  @spec transform_type_field(map()) :: map()
  defp transform_type_field(data) do
    Map.update(data, "type", "EXTERNAL_REFERENCE_TYPE_OTHER", fn type_string ->
      case EnumHelpers.string_to_external_reference_type(type_string) do
        nil -> "EXTERNAL_REFERENCE_TYPE_OTHER"
        enum_value -> Atom.to_string(enum_value)
      end
    end)
  end
end

defimpl SBoM.CycloneDX.JSON.Decodable,
  for: [
    SBoM.Cyclonedx.V17.Dependency,
    SBoM.Cyclonedx.V16.Dependency,
    SBoM.Cyclonedx.V15.Dependency,
    SBoM.Cyclonedx.V14.Dependency,
    SBoM.Cyclonedx.V13.Dependency
  ] do
  alias SBoM.CycloneDX.JSON.Decoder

  @impl Decodable
  def from_json_data(%{} = struct, data) when is_map(data) do
    data = transform_depends_on_to_dependencies(data)

    Decoder.decode_struct(struct, data)
  end

  @spec transform_depends_on_to_dependencies(map()) :: map()
  defp transform_depends_on_to_dependencies(data) do
    case Map.pop(data, "dependsOn") do
      {nil, data} ->
        data

      {[], data} ->
        data

      {depends_on, data} ->
        dependencies = Enum.map(depends_on, fn ref -> %{"ref" => ref} end)
        Map.put(data, "dependencies", dependencies)
    end
  end
end
