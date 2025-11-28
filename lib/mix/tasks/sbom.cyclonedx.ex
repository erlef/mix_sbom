# SPDX-License-Identifier: BSD-3-Clause
# SPDX-FileCopyrightText: 2025 Erlang Ecosystem Foundation

help =
  :mix
  |> SBoM.CLI.cli_def()
  |> SBoM.Util.optimus_help_to_mix_docs([:cyclonedx])

defmodule Mix.Tasks.Sbom.Cyclonedx do
  @shortdoc "Generates CycloneDX SBoM"
  @moduledoc help

  use Mix.Task

  alias SBoM.CLI

  @doc false
  @impl Mix.Task
  def run(args), do: CLI.run(["cyclonedx" | args], :mix)
end
