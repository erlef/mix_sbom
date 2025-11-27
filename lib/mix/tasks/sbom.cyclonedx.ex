# SPDX-License-Identifier: BSD-3-Clause
# SPDX-FileCopyrightText: 2025 Erlang Ecosystem Foundation

help =
  :mix
  |> SBoM.CLI.cli_def()
  |> Optimus.Help.help([:cyclonedx], 80)
  |> Enum.intersperse("\n")
  |> IO.iodata_to_binary()

defmodule Mix.Tasks.Sbom.Cyclonedx do
  @shortdoc "Generates CycloneDX SBoM"
  @moduledoc help

  use Mix.Task

  alias SBoM.CLI

  @doc false
  @impl Mix.Task
  def run(args), do: CLI.run(["cyclonedx" | args], :mix)
end
