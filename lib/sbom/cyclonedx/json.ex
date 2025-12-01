# SPDX-License-Identifier: BSD-3-Clause
# SPDX-FileCopyrightText: 2025 Erlang Ecosystem Foundation

defmodule SBoM.CycloneDX.JSON do
  @moduledoc false

  alias SBoM.CycloneDX.JSON.Decodable
  alias SBoM.CycloneDX.JSON.Encodable

  @spec encode(SBoM.CycloneDX.t(), pretty :: boolean()) :: String.t()
  def encode(bom, pretty \\ false) do
    bom
    |> Encodable.to_encodable()
    |> encode_json(pretty)
  end

  @spec decode(String.t()) :: SBoM.CycloneDX.t()
  def decode(json) do
    json_data = decode_json(json)
    version = Map.get(json_data, "specVersion", "1.6")

    # Get the appropriate BOM struct module for this version
    bom_module = SBoM.CycloneDX.bom_struct_module(:Bom, version)

    # Create empty struct and decode using our protocol
    bom_module
    |> struct()
    |> Decodable.from_json_data(json_data)
  end

  @spec encode_json(map(), boolean()) :: binary()
  defp encode_json(encodable, pretty)

  # Pretty
  cond do
    Code.ensure_loaded?(:json) and function_exported?(:json, :format, 2) ->
      defp encode_json(encodable, true) do
        :json.format(encodable, fn
          nil, _enc, _state -> <<"null">>
          other, enc, state -> :json.format_value(other, enc, state)
        end)
      end

    Code.ensure_loaded?(Jason) ->
      defp encode_json(encodable, true), do: Jason.encode!(encodable, pretty: true)

    true ->
      defp encode_json(encodable, true) do
        Mix.shell().error("""
        Pretty JSON formatting is not available.

        Options:
        1. Update to a newer version of Erlang/OTP that includes :json.format/2 (OTP 27.1 or later)
        2. Use Jason for JSON encoding (add {:jason, "~> 1.4"} to your dependencies)
        3. Disable pretty printing
        """)

        encode_json(encodable, false)
      end
  end

  # Non-pretty
  cond do
    Code.ensure_loaded?(JSON) ->
      defp encode_json(encodable, false), do: JSON.encode!(encodable)

    Code.ensure_loaded?(Jason) ->
      defp encode_json(encodable, false), do: Jason.encode!(encodable)

    true ->
      defp encode_json(_encodable, false) do
        Mix.raise("""
        JSON encoding is not available. Please either update to Elixir 1.18+ or add
        {:jason, "~> 1.4"} to your dependencies.
        """)
      end
  end

  @spec decode_json(String.t()) :: map()
  defp decode_json(json)

  cond do
    Code.ensure_loaded?(JSON) ->
      defp decode_json(json), do: JSON.decode!(json)

    Code.ensure_loaded?(Jason) ->
      defp decode_json(json), do: Jason.decode!(json)

    true ->
      defp decode_json(_json) do
        Mix.raise("""
        JSON decoding is not available. Please either update to Elixir 1.18+ or add
        {:jason, "~> 1.4"} to your dependencies.
        """)
      end
  end
end
