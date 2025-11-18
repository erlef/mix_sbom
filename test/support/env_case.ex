defmodule SBoM.EnvCase do
  @moduledoc """
  This module provides a test case to set up the environment for testing.
  """

  use ExUnit.CaseTemplate

  setup do
    env_before = System.get_env()

    # Clear GitHub Environment variables, otherwise tests in the CI will behave
    # differently
    for "GITHUB_" <> _rest = key <- Map.keys(env_before) do
      System.delete_env(key)
    end

    on_exit(fn ->
      env_after = System.get_env()

      # Restore the environment variables to their original state
      System.put_env(env_before)

      for env <- Map.keys(env_after),
          !Map.has_key?(env_before, env) do
        System.delete_env(env)
      end
    end)
  end
end
