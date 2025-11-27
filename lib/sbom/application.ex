# SPDX-License-Identifier: BSD-3-Clause
# SPDX-FileCopyrightText: 2025 Erlang Ecosystem Foundation

defmodule SBoM.Application do
  @moduledoc false

  use Application

  @impl Application
  def start(_start_type, _start_args) do
    Mix.Hex.start()

    Mix.SCM.delete(Hex.SCM)
    Mix.SCM.append(SBoM.SCM.System)
    Mix.SCM.append(Hex.SCM)

    run_cli()

    Supervisor.start_link([], strategy: :one_for_one)
  end

  @spec run_cli() :: :ok | no_return()
  case Code.ensure_loaded(Burrito) do
    {:module, Burrito} ->
      defp run_cli do
        alias Burrito.Util
        alias SBoM.CLI

        if Util.running_standalone?() do
          try do
            CLI.run(Util.Args.argv(), :burrito)

            System.stop(0)
          rescue
            e in Mix.Error ->
              IO.write(:stderr, "#{e.message}\n")
              System.halt(e.mix)
          end
        end

        :ok
      end

    _otherwise ->
      defp run_cli, do: :ok
  end
end
