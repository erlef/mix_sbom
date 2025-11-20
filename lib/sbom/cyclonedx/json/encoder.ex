# SPDX-License-Identifier: MIT AND Apache-2.0
# SPDX-FileCopyrightText: 2017-2025 The Elixir Protobuf Project Authors
# SPDX-FileCopyrightText: 2025 Erlang Ecosystem Foundation

# Heavily influenced by:
# https://github.com/elixir-protobuf/protobuf/blob/v0.15.0/lib/protobuf/json/encode.ex
# Protobuf LICENSE: https://github.com/elixir-protobuf/protobuf/blob/main/LICENSE

# credo:disable-for-this-file
defmodule SBoM.CycloneDX.JSON.Encoder do
  @moduledoc false

  alias SBoM.CycloneDX.JSON.Encodable

  @int32_types ~w(int32 sint32 sfixed32 fixed32 uint32)a
  @int64_types ~w(int64 sint64 sfixed64 fixed64 uint64)a
  @float_types [:float, :double]

  def encodable(%module{} = struct) do
    message_props = module.__message_props__()
    regular = encode_regular_fields(struct, message_props)
    oneofs = encode_oneof_fields(struct, message_props)

    :maps.from_list(regular ++ oneofs)
  end

  defp encode_regular_fields(struct, %{field_props: field_props, syntax: syntax}) do
    for {_field_num, %{name_atom: name, oneof: nil} = prop} <- field_props,
        value = Map.get(struct, name),
        emit?(syntax, prop, value) do
      encode_field(prop, value)
    end
  end

  defp encode_oneof_fields(struct, message_props) do
    %{field_tags: field_tags, field_props: field_props, oneof: oneofs} = message_props

    for {oneof_name, _index} <- oneofs,
        tag_and_value = Map.get(struct, oneof_name) do
      {tag, value} = tag_and_value
      prop = field_props[field_tags[tag]]
      encode_field(prop, value)
    end
  end

  defp encode_field(prop, value) do
    {prop.json_name, encode_value(value, prop)}
  end

  defp encode_value(nil, _prop), do: nil

  defp encode_value(value, %{type: :string} = prop) do
    maybe_repeat(prop, value, &encode_string/1)
  end

  defp encode_value(value, %{type: :bool} = prop) do
    maybe_repeat(prop, value, &encode_bool/1)
  end

  defp encode_value(value, %{type: type} = prop) when type in @int32_types do
    maybe_repeat(prop, value, &encode_int32_types(&1, type))
  end

  defp encode_value(value, %{type: type} = prop) when type in @int64_types do
    maybe_repeat(prop, value, &encode_int64_types(&1, type))
  end

  defp encode_value(value, %{type: :bytes} = prop) do
    maybe_repeat(prop, value, &encode_bytes/1)
  end

  defp encode_value(value, %{type: type} = prop) when type in @float_types do
    maybe_repeat(prop, value, &encode_float_types(&1, type))
  end

  defp encode_value(value, %{type: {:enum, enum}} = prop) do
    maybe_repeat(prop, value, &encode_enum(enum, &1))
  end

  defp encode_value(map, %{map?: true, type: module}) do
    %{field_props: field_props, field_tags: field_tags} = module.__message_props__()
    key_prop = field_props[field_tags[:key]]
    value_prop = field_props[field_tags[:value]]

    for {key, val} <- map, into: %{} do
      name = encode_value(key, key_prop)
      value = encode_value(val, value_prop)

      {to_string(name), value}
    end
  end

  defp encode_value(value, %{embedded?: true} = prop) do
    maybe_repeat(prop, value, fn value ->
      Encodable.to_encodable(value)
    end)
  end

  defp maybe_repeat(%{repeated?: true}, values, fun) when is_list(values) do
    Enum.map(values, fun)
  end

  defp maybe_repeat(%{repeated?: false}, value, fun) do
    fun.(value)
  end

  defp emit?(:proto3, _prop, nil), do: false
  defp emit?(:proto3, %{type: :string}, ""), do: false
  defp emit?(:proto3, %{type: :bytes}, <<>>), do: false
  defp emit?(:proto3, %{type: type}, 0) when type in @int32_types, do: false
  defp emit?(:proto3, %{type: type}, 0) when type in @int64_types, do: false
  defp emit?(:proto3, %{type: type}, +0.0) when type in @float_types, do: false
  defp emit?(:proto3, %{type: type}, -0.0) when type in @float_types, do: false
  defp emit?(:proto3, %{type: :bool}, false), do: false
  defp emit?(:proto3, %{type: {:enum, _enum}}, 0), do: false
  defp emit?(:proto3, %{repeated?: true}, []), do: false
  defp emit?(:proto3, %{map?: true}, map) when map_size(map) == 0, do: false
  defp emit?(_version, _prop, _value), do: true

  defp encode_string(value) when is_binary(value), do: value

  defp encode_bool(value) when is_boolean(value), do: value

  defp encode_int32_types(value, _type) when is_integer(value), do: value

  defp encode_int64_types(value, _type) when is_integer(value), do: Integer.to_string(value)

  defp encode_bytes(value) when is_binary(value), do: Base.encode64(value)

  defp encode_float_types(value, _type) when is_float(value), do: value
  defp encode_float_types(:negative_infinity, _type), do: "-Infinity"
  defp encode_float_types(:infinity, _type), do: "Infinity"
  defp encode_float_types(:nan, _type), do: "NaN"

  defp encode_enum(enum, key) when is_atom(key) do
    %{^key => _tag} = enum.mapping()
    key
  end

  defp encode_enum(enum, num) when is_integer(num) do
    mapping = enum.mapping()
    {key, ^num} = Enum.find(mapping, fn {_key, tag} -> tag == num end)
    key
  end
end
