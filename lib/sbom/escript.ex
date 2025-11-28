# SPDX-License-Identifier: BSD-3-Clause
# SPDX-FileCopyrightText: 2025 Erlang Ecosystem Foundation

defmodule SBoM.Escript do
  @moduledoc false

  # Escript entry point for generating CycloneDX SBoMs.

  alias SBoM.CLI

  @spec main(OptionParser.argv()) :: :ok
  def main(args) do
    CLI.run(args, :escript)
  rescue
    e in Mix.Error ->
      IO.write(:stderr, "#{e.message}\n")
      System.halt(e.mix)
  end
end
