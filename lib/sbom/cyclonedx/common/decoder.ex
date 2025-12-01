# SPDX-License-Identifier: BSD-3-Clause AND MIT AND Apache-2.0
# SPDX-FileCopyrightText: 2017-2025 The Elixir Protobuf Project Authors
# SPDX-FileCopyrightText: 2025 Erlang Ecosystem Foundation

# Heavily influenced by:
# https://github.com/elixir-protobuf/protobuf/blob/v0.15.0/lib/protobuf/json/decode.ex
# Protobuf LICENSE: https://github.com/elixir-protobuf/protobuf/blob/main/LICENSE

defmodule SBoM.CycloneDX.Common.Decoder do
  @moduledoc false

  alias Google.Protobuf.NullValue
  alias SBoM.CycloneDX.Common.Constants

  @compile {:inline, decode_integer: 1, decode_float: 1, parse_float: 1, decode_bytes: 1, decode_key: 3, parse_key: 2}

  @int32_range Constants.int32_range()
  @int_ranges Constants.int_ranges()
  @int_types Constants.int_types()
  @float_range Constants.float_range()
  @float_types Constants.float_types()

  @spec decode_struct(struct(), map(), module()) :: struct()
  def decode_struct(struct, data, field_access_impl) when is_map(data) do
    message_props = struct.__struct__.__message_props__()
    regular = decode_regular_fields(data, message_props, field_access_impl)
    oneofs = decode_oneof_fields(data, message_props, field_access_impl)

    struct
    |> struct(regular)
    |> struct(oneofs)
    |> transform_module(struct.__struct__)
  end

  @spec decode_regular_fields(map(), map(), module()) :: keyword()
  def decode_regular_fields(data, %{field_props: field_props}, field_access_impl) do
    Enum.flat_map(field_props, fn
      {_field_num, %Protobuf.FieldProps{oneof: nil} = prop} ->
        decode_regular_field(prop, data, field_access_impl)

      {_field_num, _prop} ->
        []
    end)
  end

  @spec decode_regular_field(Protobuf.FieldProps.t(), map(), module()) :: keyword()
  defp decode_regular_field(prop, data, field_access_impl) do
    case field_access_impl.fetch_field_value(prop, data) do
      {:ok, value} ->
        build_field_result(prop, value, field_access_impl)

      :error ->
        []
    end
  end

  @spec build_field_result(Protobuf.FieldProps.t(), term(), module()) :: keyword()
  defp build_field_result(prop, value, field_access_impl) do
    case decode_value(prop, value, field_access_impl) do
      nil -> []
      decoded_value -> [{prop.name_atom, decoded_value}]
    end
  end

  @spec decode_oneof_fields(map(), map(), module()) :: map()
  def decode_oneof_fields(data, %{field_props: field_props, oneof: oneofs}, field_access_impl) do
    for_result =
      for {oneof, index} <- oneofs,
          {_field_num, %{oneof: ^index} = prop} <- field_props,
          result = field_access_impl.fetch_field_value(prop, data),
          match?({:ok, _value}, result),
          {:ok, value} = result,
          not null_value?(value, prop) do
        {oneof, prop.name_atom, decode_value(prop, value, field_access_impl)}
      end

    Enum.reduce(for_result, %{}, fn {oneof, name, decoded_value}, acc ->
      if Map.has_key?(acc, oneof) do
        throw({:duplicated_oneof, oneof})
      else
        Map.put(acc, oneof, {name, decoded_value})
      end
    end)
  end

  @spec null_value?(term(), Protobuf.FieldProps.t()) :: boolean()
  defp null_value?(nil, %Protobuf.FieldProps{type: {:enum, NullValue}}), do: false
  defp null_value?(value, _props), do: is_nil(value)

  @spec decode_value(Protobuf.FieldProps.t(), term(), module()) :: term()
  defp decode_value(%{optional?: true, type: type}, nil, _field_access_impl) when type != Google.Protobuf.Value, do: nil

  defp decode_value(%{map?: true} = prop, map, field_access_impl), do: decode_map(prop, map, field_access_impl)

  defp decode_value(%{repeated?: true} = prop, list, field_access_impl),
    do: decode_repeated(prop, list, field_access_impl)

  defp decode_value(%{repeated?: false} = prop, value, field_access_impl),
    do: decode_singular(prop, value, field_access_impl)

  @spec decode_map(Protobuf.FieldProps.t(), term(), module()) :: term()
  defp decode_map(%{type: module, name_atom: field}, map, field_access_impl) when is_map(map) do
    %{field_props: field_props, field_tags: field_tags} = module.__message_props__()
    key_type = field_props[field_tags[:key]].type
    val_prop = field_props[field_tags[:value]]

    for {key, val} <- map, into: %{} do
      {decode_key(key_type, key, field), decode_singular(val_prop, val, field_access_impl)}
    end
  end

  defp decode_map(_prop, nil, _field_access_impl), do: nil

  defp decode_map(prop, bad_map, _field_access_impl), do: throw({:bad_map, prop.name_atom, bad_map})

  @spec decode_key(atom(), term(), atom()) :: term()
  defp decode_key(type, key, field) when is_binary(key) do
    case parse_key(type, key) do
      {:ok, decoded} -> decoded
      :error -> throw({:bad_map_key, field, type, key})
    end
  end

  defp decode_key(type, key, field), do: throw({:bad_map_key, field, type, key})

  @spec parse_key(atom(), String.t()) :: {:ok, term()} | :error
  defp parse_key(:string, key), do: {:ok, key}
  defp parse_key(:bool, "true"), do: {:ok, true}
  defp parse_key(:bool, "false"), do: {:ok, false}
  defp parse_key(type, key) when type in @int_types, do: parse_int(key)
  defp parse_key(_type, _key), do: :error

  @spec decode_repeated(Protobuf.FieldProps.t(), term(), module()) :: term()
  defp decode_repeated(prop, elements, field_access_impl) when is_list(elements) do
    for element <- elements, do: decode_singular(prop, element, field_access_impl)
  end

  defp decode_repeated(_prop, nil, _field_access_impl), do: nil

  defp decode_repeated(prop, value, _field_access_impl) do
    throw({:bad_repeated, prop.name_atom, value})
  end

  @spec decode_singular(Protobuf.FieldProps.t(), term(), module()) :: term()
  defp decode_singular(%{type: type} = prop, value, field_access_impl)
       when type in [:string, :bytes] or type in @int_types or type in @float_types do
    decode_scalar(type, prop.name_atom, value, field_access_impl)
  end

  defp decode_singular(%{type: :bool} = prop, value, field_access_impl) do
    field_access_impl.decode_bool_scalar(prop.name_atom, value)
  end

  defp decode_singular(%{type: {:enum, enum}} = prop, value, _field_access_impl) do
    Map.get_lazy(enum.__reverse_mapping__(), value, fn ->
      cond do
        is_integer(value) and value in @int32_range -> value
        is_nil(value) and enum == NullValue -> :NULL_VALUE
        true -> throw({:bad_enum, prop.name_atom, value})
      end
    end)
  end

  defp decode_singular(%{type: module, embedded?: true}, value, field_access_impl) do
    field_access_impl.decode_embedded(value, module)
  end

  @spec decode_scalar(atom(), atom(), term(), module()) :: term()
  def decode_scalar(:string, name, value, _field_access_impl) do
    if is_binary(value), do: value, else: throw({:bad_string, name, value})
  end

  @spec decode_scalar(atom(), atom(), term(), module()) :: term()
  def decode_scalar(type, name, value, _field_access_impl) when type in @int_types do
    with {:ok, integer} <- decode_integer(value),
         true <- integer in @int_ranges[type] do
      integer
    else
      _error -> throw({:bad_int, name, value})
    end
  end

  def decode_scalar(type, name, value, _field_access_impl) when type in @float_types do
    {float_min, float_max} = @float_range

    case decode_float(value) do
      {:ok, float}
      when type == :float and is_float(float) and (float < float_min or float > float_max) ->
        throw({:bad_float, name, value})

      {:ok, value} ->
        value

      :error ->
        throw({:bad_float, name, value})
    end
  end

  def decode_scalar(:bytes, name, value, _field_access_impl) do
    with true <- is_binary(value),
         {:ok, bytes} <- decode_bytes(value) do
      bytes
    else
      _error -> throw({:bad_bytes, name})
    end
  end

  @spec decode_integer(term()) :: {:ok, integer()} | :error
  defp decode_integer(integer) when is_integer(integer), do: {:ok, integer}
  defp decode_integer(string) when is_binary(string), do: parse_int(string)
  defp decode_integer(float) when is_float(float), do: parse_float_as_int(float)
  defp decode_integer(_bad), do: :error

  @spec parse_int(String.t()) :: {:ok, integer()} | :error
  defp parse_int(string) do
    case Integer.parse(string) do
      {int, ""} ->
        {:ok, int}

      _no_integer ->
        case Float.parse(string) do
          {float, ""} ->
            parse_float_as_int(float)

          _no_float ->
            :error
        end
    end
  end

  @spec parse_float_as_int(float()) :: {:ok, integer()} | :error
  defp parse_float_as_int(float) do
    truncated = trunc(float)

    if float - truncated == 0.0 do
      {:ok, truncated}
    else
      :error
    end
  end

  @spec decode_float(term()) :: {:ok, float() | :infinity | :negative_infinity | :nan} | :error
  defp decode_float(float) when is_float(float), do: {:ok, float}
  defp decode_float(integer) when is_integer(integer), do: {:ok, integer / 1}
  defp decode_float(string) when is_binary(string), do: parse_float(string)
  defp decode_float(_bad), do: :error

  @spec parse_float(String.t()) :: {:ok, float() | :infinity | :negative_infinity | :nan} | :error
  defp parse_float("-Infinity"), do: {:ok, :negative_infinity}
  defp parse_float("Infinity"), do: {:ok, :infinity}
  defp parse_float("NaN"), do: {:ok, :nan}

  defp parse_float(string) do
    case Float.parse(string) do
      {float, ""} -> {:ok, float}
      _no_match -> :error
    end
  end

  @spec decode_bytes(String.t()) :: {:ok, binary()} | :error
  defp decode_bytes(bytes) do
    pattern = :binary.compile_pattern(["-", "_"])

    if String.contains?(bytes, pattern) do
      Base.url_decode64(bytes, padding: false)
    else
      Base.decode64(bytes, padding: false)
    end
  end

  @spec transform_module(struct(), module()) :: struct()
  def transform_module(message, module) do
    if transform_module = module.transform_module() do
      transform_module.decode(message, module)
    else
      message
    end
  end

  @spec convert_field_mask_to_underscore(String.t()) :: String.t()
  def convert_field_mask_to_underscore(mask) do
    if mask =~ ~r/^[a-zA-Z0-9\\.]+$/ do
      mask
      |> String.split(".")
      |> Enum.map_join(".", &Macro.underscore/1)
    else
      throw({:bad_field_mask, mask})
    end
  end
end
