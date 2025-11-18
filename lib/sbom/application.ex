defmodule SBoM.Application do
  @moduledoc false

  use Application

  alias Burrito.Util.Args
  alias SBoM.Escript

  require Logger

  @impl Application
  def start(_start_type, _start_args) do
    Mix.Hex.start()

    Mix.SCM.delete(Hex.SCM)
    Mix.SCM.append(SBoM.SCM.System)
    Mix.SCM.append(Hex.SCM)

    if Burrito.Util.running_standalone?() do
      Escript.main(Args.argv())

      System.stop(0)
    end

    Supervisor.start_link([], strategy: :one_for_one)
  end
end
