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

        if Util.running_standalone?() do
          SBoM.Escript.main(Util.Args.argv())

          System.stop(0)
        end

        :ok
      end

    _otherwise ->
      defp run_cli, do: :ok
  end
end
