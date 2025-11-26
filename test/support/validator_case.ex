# SPDX-License-Identifier: BSD-3-Clause
# SPDX-FileCopyrightText: 2025 Erlang Ecosystem Foundation

defmodule SBoM.ValidatorCase do
  @moduledoc false
  use ExUnit.CaseTemplate

  using do
    quote do
      import unquote(__MODULE__)
    end
  end

  defmacro assert_valid_cyclonedx_bom(bom_path, format) do
    quote bind_quoted: [bom_path: bom_path, format: format] do
      case format do
        :protobuf ->
          assert {_out, 0} =
                   System.cmd(
                     cyclonedx_cli_path(),
                     [
                       "convert",
                       "--input-file",
                       bom_path,
                       "--output-file",
                       "#{bom_path}.json",
                       "--input-format",
                       "protobuf",
                       "--output-format",
                       "json"
                     ],
                     stderr_to_stdout: true,
                     env: %{}
                   )

          assert {_out, 0} =
                   System.cmd(
                     cyclonedx_cli_path(),
                     ["validate", "--input-file", "#{bom_path}.json", "--input-format", "json"],
                     stderr_to_stdout: true,
                     env: %{}
                   )

        _other ->
          assert {_out, 0} =
                   System.cmd(
                     cyclonedx_cli_path(),
                     ["validate", "--input-file", bom_path, "--input-format", format],
                     stderr_to_stdout: true,
                     env: %{}
                   )
      end
    end
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
end
