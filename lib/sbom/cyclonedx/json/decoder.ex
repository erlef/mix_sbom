# SPDX-License-Identifier: BSD-3-Clause
# SPDX-FileCopyrightText: 2025 Erlang Ecosystem Foundation

# credo:disable-for-this-file
defmodule SBoM.CycloneDX.JSON.Decoder do
  @moduledoc false

  @behaviour SBoM.CycloneDX.Common.FieldAccess

  alias SBoM.CycloneDX.Common.Decoder
  alias SBoM.CycloneDX.Common.FieldAccess
  alias SBoM.CycloneDX.JSON.Decodable

  @spec from_json_data(term(), module()) :: struct()
  def from_json_data(data, module) when is_atom(module) do
    Decodable.from_json_data(struct(module), data)
  end

  def decode_struct(struct, data) when is_map(data) do
    Decoder.decode_struct(struct, data, __MODULE__)
  end

  @impl FieldAccess
  def fetch_field_value(%Protobuf.FieldProps{name: name_key, json_name: json_key}, data) do
    case data do
      %{^json_key => value} -> {:ok, value}
      %{^name_key => value} -> {:ok, value}
      _ -> :error
    end
  end

  @impl FieldAccess
  def decode_bool_scalar(name, value) do
    if is_boolean(value), do: value, else: throw({:bad_bool, name, value})
  end

  @impl FieldAccess
  def decode_embedded(value, module) do
    from_json_data(value, module)
  end

  def decode_scalar(type, name, value) do
    Decoder.decode_scalar(type, name, value, __MODULE__)
  end

  defdelegate transform_module(message, module), to: Decoder
end
