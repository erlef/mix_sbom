defmodule SBoM.FixtureCase do
  @moduledoc false
  use ExUnit.CaseTemplate

  import SBoM.Util, only: [hash_app_name: 1]

  using do
    quote do
      import unquote(__MODULE__)
    end
  end

  setup tags do
    on_exit(fn -> Mix.Project.clear_deps_cache() end)

    if tags[:tmp_dir] && tags[:fixture_app] do
      prepare_fixture(tags[:fixture_app], tags[:tmp_dir])

      {:ok, app_path: tags[:tmp_dir]}
    else
      :ok
    end
  end

  @spec prepare_fixture(fixture_app :: String.t(), dest_dir :: Path.t()) :: :ok
  def prepare_fixture(fixture_app, dest_dir) do
    fixture_app |> app_fixture_path() |> File.cp_r!(dest_dir)

    mix_file_path = Path.join(dest_dir, "mix.exs")

    if File.exists?(mix_file_path) do
      app_name = hash_app_name(dest_dir)

      rewrite_app_name(mix_file_path, app_name)
    end

    :ok
  end

  @spec app_fixture_path(app :: String.t()) :: Path.t()
  def app_fixture_path(app), do: Path.expand("../../test/fixtures/#{app}", __DIR__)

  @spec rewrite_app_name(mix_file_path :: Path.t(), name :: String.t()) :: :ok
  def rewrite_app_name(mix_file_path, name) do
    mix_file_path
    |> File.read!()
    |> String.replace(inspect(:app_name_to_replace), ":" <> name)
    |> String.replace(
      inspect(AppNameToReplace.MixProject),
      # credo:disable-for-next-line Credo.Check.Warning.UnsafeToAtom
      inspect(Module.concat(["Elixir", Macro.camelize(name), "MixProject"]))
    )
    |> then(&File.write!(mix_file_path, &1))
  end
end
