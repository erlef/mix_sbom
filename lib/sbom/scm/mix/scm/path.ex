defmodule SBoM.SCM.Mix.SCM.Path do
  @moduledoc """
  SCM implementation for path-based Mix dependencies.

  Generates a generic `purl` for dependencies declared with `:path` in
  `mix.exs`.
  """

  @behaviour SBoM.SCM

  alias SBoM.SCM

  @doc """
  Creates a generic package URL (`purl`) from a path-based Mix dependency.

  Uses the `requirement` from `mix.exs`, or falls back to the version if available.

  ## Examples

      iex> SBoM.SCM.Mix.SCM.Path.mix_dep_to_purl(
      ...>   {:my_dep, "~> 0.1.0", path: "deps/my_dep"},
      ...>   nil
      ...> )
      %Purl{
        type: "generic",
        name: "my_dep",
        version: "~> 0.1.0"
      }

      iex> SBoM.SCM.Mix.SCM.Path.mix_dep_to_purl(
      ...>   {:my_dep, nil, path: "deps/my_dep"},
      ...>   "0.1.0"
      ...> )
      %Purl{
        type: "generic",
        name: "my_dep",
        version: "0.1.0"
      }

  """
  @impl SCM
  def mix_dep_to_purl({app, requirement, _opts}, version) do
    Purl.new!(%Purl{
      type: "generic",
      name: Atom.to_string(app),
      version: requirement || version
    })
  end
end
