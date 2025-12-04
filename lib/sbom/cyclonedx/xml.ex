# SPDX-License-Identifier: BSD-3-Clause
# SPDX-FileCopyrightText: 2025 Erlang Ecosystem Foundation

defmodule SBoM.CycloneDX.XML do
  @moduledoc false

  import Record, only: [defrecord: 3, extract: 2]

  alias SBoM.CycloneDX.XML.Decodable
  alias SBoM.CycloneDX.XML.Encodable

  @xml_prolog ~c"<?xml version=\"1.0\" encoding=\"utf-8\"?>"

  defrecord :xml_element, :xmlElement, extract(:xmlElement, from_lib: "xmerl/include/xmerl.hrl")

  defrecord :xml_attribute,
            :xmlAttribute,
            extract(:xmlAttribute, from_lib: "xmerl/include/xmerl.hrl")

  defrecord :xml_text, :xmlText, extract(:xmlText, from_lib: "xmerl/include/xmerl.hrl")

  @spec encode(SBoM.CycloneDX.t(), pretty :: boolean()) :: String.t()
  def encode(bom, pretty) do
    bom
    |> Encodable.to_xml_element()
    |> encode_xml(pretty)
  end

  @spec decode(String.t()) :: SBoM.CycloneDX.t()
  def decode(string) do
    {encoding, bom_length} = :unicode.bom_to_encoding(string)
    input_length = byte_size(string)

    {root_element, []} =
      string
      |> binary_part(bom_length, input_length - bom_length)
      |> :unicode.characters_to_binary(encoding)
      |> :erlang.binary_to_list()
      |> :xmerl_scan.string(validation: :schema)

    version = detect_version(root_element)

    :Bom
    |> SBoM.CycloneDX.bom_struct_module(version)
    |> struct()
    |> Decodable.from_xml_element(root_element)
  end

  @spec detect_version(:xmerl.xmlElement()) :: String.t()
  def detect_version(root_element) do
    "http://cyclonedx.org/schema/bom/" <> version =
      root_element
      |> xml_element(:attributes)
      |> Enum.find_value(fn
        xml_attribute(name: :xmlns, value: xmlns) -> xmlns
        _attribute -> false
      end)
      |> List.to_string()

    version
  end

  @spec encode_xml(term(), boolean()) :: iodata()
  defp encode_xml(xml_element, pretty) do
    xml_element
    |> List.wrap()
    |> :xmerl.export_simple(xml_callback(pretty), prolog: @xml_prolog)
    |> IO.iodata_to_binary()
    |> then(&(:unicode.encoding_to_bom(:utf8) <> &1))
  end

  @spec xml_callback(boolean()) :: module()
  defp xml_callback(pretty)

  case Code.ensure_loaded(:xmerl_xml_indent) do
    {:module, :xmerl_xml_indent} ->
      defp xml_callback(true), do: :xmerl_xml_indent

    {:error, _reason} ->
      defp xml_callback(true) do
        raise """
        Pretty XML formatting is not available.

        Options:
        1. Update to a newer version of Erlang/OTP (OTP 27.0 or later)
        2. Disable pretty printing
        """
      end
  end

  defp xml_callback(false), do: :xmerl_xml
end
