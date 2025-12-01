# SPDX-License-Identifier: BSD-3-Clause
# SPDX-FileCopyrightText: 2025 Erlang Ecosystem Foundation

defmodule SBoM.ValidatorCase do
  @moduledoc false
  use ExUnit.CaseTemplate

  alias SBoM.CycloneDX

  using do
    quote do
      import unquote(__MODULE__)
    end
  end

  defmacro assert_valid_cyclonedx_bom(bom_path, format) do
    quote bind_quoted: [bom_path: bom_path, format: format], generated: true do
      case format do
        :protobuf ->
          json_path = "#{bom_path}.json"
          convert_cyclonedx_bom(bom_path, json_path, :protobuf, :json)
          validate_cyclonedx_bom(json_path, :json)

        _other ->
          validate_cyclonedx_bom(bom_path, format)
      end
    end
  end

  @spec convert_cyclonedx_bom(Path.t(), Path.t(), atom(), atom()) :: :ok
  def convert_cyclonedx_bom(input_path, output_path, input_format, output_format) do
    {_out, 0} =
      System.cmd(
        cyclonedx_cli_path(),
        [
          "convert",
          "--input-file",
          input_path,
          "--output-file",
          output_path,
          "--input-format",
          to_string(input_format),
          "--output-format",
          to_string(output_format)
        ],
        stderr_to_stdout: true,
        env: %{}
      )

    :ok
  end

  @spec validate_cyclonedx_bom(Path.t(), atom()) :: :ok
  def validate_cyclonedx_bom(bom_path, format) do
    {_out, 0} =
      System.cmd(
        cyclonedx_cli_path(),
        ["validate", "--input-file", bom_path, "--input-format", to_string(format)],
        stderr_to_stdout: true,
        env: %{}
      )

    :ok
  end

  @spec cyclonedx_cli_path() :: Path.t()
  def cyclonedx_cli_path do
    ["cyclonedx-cli", "cyclonedx"]
    |> Enum.find_value(&System.find_executable/1)
    |> case do
      nil -> raise "cyclonedx-cli not found in PATH"
      path -> path
    end
  end

  @spec cannonicalize_bom(CycloneDX.t()) :: CycloneDX.t()
  def cannonicalize_bom(%{} = bom) do
    bom
    # The cyclonedx cli can't discern the version from the file if there's no
    # relevant changes in the protobuf schema, so we just ignore it.
    |> ignore_bom_version()
    # Not all formats can discern nil vs "", so we drop empty strings
    |> replace_empty_strings()
  end

  @spec ignore_bom_version(CycloneDX.t()) :: CycloneDX.t()
  defp ignore_bom_version(%{} = bom), do: %{bom | spec_version: :ignore}

  @spec replace_empty_strings(any()) :: any()
  defp replace_empty_strings(value)

  defp replace_empty_strings(%struct{} = value) do
    struct(struct, value |> Map.from_struct() |> replace_empty_strings())
  end

  defp replace_empty_strings(value) when is_map(value) do
    Map.new(value, fn
      {key, ""} -> {key, nil}
      {key, []} -> {key, nil}
      {key, val} -> {key, replace_empty_strings(val)}
    end)
  end

  defp replace_empty_strings(value) when is_list(value) do
    Enum.map(value, fn
      "" -> nil
      val -> replace_empty_strings(val)
    end)
  end

  defp replace_empty_strings(""), do: nil
  defp replace_empty_strings(value), do: value
end
