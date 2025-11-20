defmodule SBoM.SCM do
  @moduledoc """
  Defines the behavior and helper types for working with source control managers
  (SCMs) in the Mix dependency submission context.

  SCM implementations are responsible for generating package URLs (`purl`) and
  extracting dependency metadata from `mix.lock` or `mix.exs`.

  Implementations must live under `SBoM.SCM.[NAME]` and match
  the name of the corresponding module in `Mix.SCM.available/0`.
  """

  @typedoc """
  Lock for the dependency as a list.

  **Always only match the start of the list. The list can be extended in the
  future.**

  ## Examples

      [
        :hex,
        :jason,
        "1.4.0",
        "e855647bc964a44e2f67df589ccf49105ae039d4179db7f6271dfd3843dc27e6",
        [:mix],
        [
          {:decimal, "~> 1.0 or ~> 2.0",
          [hex: :decimal, repo: "hexpm", optional: true]}
        ],
        "hexpm",
        "79a3791085b2a0f743ca04cec0f7be26443738779d09302e01318f97bdb82121"
      ]

  """
  @type lock :: list()

  @type app_name() :: Application.app()
  @type dep() :: {app_name(), requirement :: String.t() | nil, opts :: Keyword.t()}

  @doc """
  Creates a package URL (`purl`) from a declared dependency.

  Implementations are expected to convert the given Mix dependency (from `mix.exs`)
  into a `Purl` struct.
  """
  @callback mix_dep_to_purl(dep(), version :: String.t() | nil) :: Purl.t()

  @doc """
  Creates a package URL (`purl`) from a locked dependency.

  This is used when data is available from `mix.lock`.
  """
  @callback mix_lock_to_purl(app :: atom(), lock :: lock()) :: Purl.t()

  @doc """
  Returns a list of app names representing sub-dependencies found in the lock.

  Only used if the SCM implementation supports this and provides custom logic.
  """
  @callback mix_lock_deps(lock :: lock()) :: [app_name()]

  @optional_callbacks mix_lock_deps: 1, mix_lock_to_purl: 2

  @doc """
  Returns the module implementing SCM-specific behavior for a given SCM module.

  Looks for a corresponding module under `SBoM.SCM.*`.

  Returns `nil` if no implementation exists or the module is not loaded.

  ## Examples

      iex> SBoM.SCM.implementation(Mix.SCM.Path)
      SBoM.SCM.Mix.SCM.Path

      iex> SBoM.SCM.implementation(Unknown.SCM)
      nil

  """
  @spec implementation(module()) :: module() | nil
  def implementation(scm) when is_atom(scm) do
    if scm in Mix.SCM.available() do
      # We're looking for this module, safe_concat can't be used
      # Security Impact is negligeble since the SCM has to be registered with
      # Mix.SCM.available()
      # credo:disable-for-next-line Credo.Check.Warning.UnsafeToAtom
      scm_impl = Module.concat(__MODULE__, scm)

      case Code.ensure_loaded(scm_impl) do
        {:module, ^scm_impl} ->
          scm_impl

        # SCM not implemented
        {:error, _reason} ->
          nil
      end
    end
  end
end
