# SPDX-License-Identifier: BSD-3-Clause
# SPDX-FileCopyrightText: 2025 Erlang Ecosystem Foundation

defmodule SBoM.Util do
  @moduledoc false

  @spec in_project(path :: Path.t(), fun :: (module() | nil -> result)) :: result
        when result: term()
  def in_project(path, fun) do
    setup_context(fn ->
      path
      # We need a different atom name per path to avoid cache confusion
      # We can't pass the actual application name, since that is only known once
      # the application is laoded
      |> hash_app_name()
      # This will be called one per path containing a mix.exs
      # Theoretically, a DOS vulnerability is possible by trying to submit on
      # a project containing millions of mix.exs files. This is prevented by
      # restricting the amount of files to be scanned.
      # credo:disable-for-next-line Credo.Check.Warning.UnsafeToAtom
      |> String.to_atom()
      |> Mix.Project.in_project(path, fn
        nil -> nil
        module -> fun.(module)
      end)
    end)
  end

  @spec setup_context(fun :: (-> result)) :: result when result: term()
  defp setup_context(fun) do
    with_ignored_module_conflicts(fn ->
      on_clean_slate(fun)
    end)
  end

  @spec on_clean_slate(fun :: (-> result)) :: result when result: term()
  defp on_clean_slate(fun)

  case Mix.env() do
    env when env in [:dev, :test] ->
      defp on_clean_slate(fun) do
        # This is an internal API that we need to call if the exection is run
        # using mix (eg `mix test`).
        # Since it is not part of the production build, this is acceptable.
        Mix.ProjectStack.on_clean_slate(fun)
      end

    _env ->
      defp on_clean_slate(fun), do: fun.()
  end

  @spec with_ignored_module_conflicts(fun :: (-> result)) :: result when result: term()
  defp with_ignored_module_conflicts(fun) do
    ignore_module_conflict = Code.get_compiler_option(:ignore_module_conflict)

    try do
      # Ignore Duplicated MixFiles
      Code.put_compiler_option(:ignore_module_conflict, true)

      fun.()
    after
      Code.put_compiler_option(:ignore_module_conflict, ignore_module_conflict)
    end
  end

  @spec hash_app_name(seed :: iodata()) :: String.t()
  def hash_app_name(seed) do
    seed |> :erlang.crc32() |> Integer.digits(26) |> Enum.map(&(&1 + ?a)) |> List.to_string()
  end
end
