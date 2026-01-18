# SPDX-License-Identifier: BSD-3-Clause
# SPDX-FileCopyrightText: 2025 Erlang Ecosystem Foundation

defmodule SBoM.SCM.System do
  @moduledoc false

  # A `Mix.SCM` implementation that looks up the system dependencies.
  # (Erlang, Elixir, Hex, etc.)

  @behaviour Mix.SCM

  @elixir_applications ~w[eex elixir ex_unit iex logger mix]a
  defguard is_elixir_app(app) when app in @elixir_applications

  {:ok, dirs} = :file.list_dir_all(:code.lib_dir())

  @erlang_applications Enum.map(dirs, fn dir ->
                         [name, _version] = dir |> List.to_string() |> String.split("-", parts: 2)
                         String.to_atom(name)
                       end)

  defguard is_erlang_app(app) when app in @erlang_applications

  defguard is_hex_app(app) when app == :hex
  defguard is_system_app(app) when is_elixir_app(app) or is_erlang_app(app) or is_hex_app(app)

  @impl Mix.SCM
  def accepts_options(app, opts)

  def accepts_options(app, opts) when is_system_app(app) do
    opts = Keyword.put(opts, :app, app)

    if reachable_application?(app) do
      Keyword.merge(opts, build: Application.app_dir(app), dest: Application.app_dir(app))
    else
      opts
    end
  end

  def accepts_options(_app, _opts), do: nil

  @impl Mix.SCM
  def fetchable?, do: false

  @impl Mix.SCM
  def format(opts), do: opts[:app]

  @impl Mix.SCM
  def format_lock(_opts), do: nil

  @impl Mix.SCM
  def checked_out?(_opts), do: true

  @impl Mix.SCM
  def lock_status(_opts), do: :ok

  @impl Mix.SCM
  def equal?(opts1, opts2), do: opts1[:app] == opts2[:app]

  @impl Mix.SCM
  def managers(_opts), do: []

  @impl Mix.SCM
  @dialyzer {:no_return, checkout: 1}
  def checkout(_opts), do: Mix.raise("System SCM does not support checkout.")

  @impl Mix.SCM
  @dialyzer {:no_return, update: 1}
  def update(_opts), do: Mix.raise("System SCM does not support update.")

  @spec reachable_application?(app :: atom()) :: boolean()
  defp reachable_application?(app) do
    case Application.load(app) do
      :ok -> true
      {:error, {:already_loaded, ^app}} -> true
      {:error, {~c"no such file or directory", _app}} -> false
    end
  end
end

defmodule SBoM.SCM.SBoM.SCM.System do
  @moduledoc false

  # `SBoM.SCM` implementation for system dependencies.

  @behaviour SBoM.SCM

  import SBoM.SCM.System,
    only: [is_elixir_app: 1, is_erlang_app: 1, is_hex_app: 1]

  @impl SBoM.SCM
  def mix_dep_to_purl(app, version)

  def mix_dep_to_purl({app, _version_requirement, _opts}, version) when is_elixir_app(app) do
    git_ref =
      case version do
        nil -> "heads/main"
        v -> "tags/v#{v}"
      end

    Purl.new!(%Purl{
      type: "otp",
      name: to_string(app),
      subpath: ["lib", to_string(app)],
      version: version,
      qualifiers: %{
        "repository_url" => "https://github.com/elixir-lang/elixir",
        "download_url" => "https://github.com/elixir-lang/elixir/archive/refs/#{git_ref}.zip",
        "vcs_url" => "git+https://github.com/elixir-lang/elixir.git"
      }
    })
  end

  def mix_dep_to_purl({app, _version_requirement, _opts}, version) when is_erlang_app(app) do
    git_ref =
      case version do
        nil -> "heads/master"
        v -> "tags/OTP-#{v}"
      end

    Purl.new!(%Purl{
      type: "otp",
      name: to_string(app),
      subpath: ["lib", to_string(app)],
      qualifiers: %{
        "repository_url" => "https://github.com/erlang/otp",
        "download_url" => "https://github.com/erlang/otp/archive/refs/#{git_ref}.zip",
        "vcs_url" => "git+https://github.com/erlang/otp.git"
      }
    })
  end

  def mix_dep_to_purl({app, _version_requirement, _opts}, version) when is_hex_app(app) do
    git_ref =
      case version do
        nil -> "heads/main"
        v -> "tags/v#{v}"
      end

    Purl.new!(%Purl{
      type: "otp",
      name: to_string(app),
      qualifiers: %{
        "repository_url" => "https://github.com/hexpm/hex",
        "download_url" => "https://github.com/hexpm/hex/archive/refs/#{git_ref}.zip",
        "vcs_url" => "git+https://github.com/hexpm/hex.git"
      }
    })
  end

  def mix_dep_to_purl({app, _version_requirement, _opts}, version) do
    Purl.new!(%Purl{
      type: "otp",
      name: to_string(app),
      version: version
    })
  end

  @impl SBoM.SCM
  def enhance_metadata(app, _dependency)

  def enhance_metadata(app, _dependency) when is_elixir_app(app) do
    %{
      licenses:
        case app do
          :elixir -> ["Apache-2.0", "LicenseRef-scancode-unicode"]
          _app -> ["Apache-2.0"]
        end,
      source_url: "git+https://github.com/elixir-lang/elixir.git#lib/#{app}",
      links: %{
        "github" => "https://github.com/elixir-lang/elixir",
        "website" => "https://elixir-lang.org"
      }
    }
  end

  def enhance_metadata(app, _dependency) when is_erlang_app(app) do
    %{
      licenses: ["Apache-2.0"],
      source_url: "git+https://github.com/erlang/otp.git#lib/#{app}",
      links: %{
        "github" => "https://github.com/erlang/otp",
        "website" => "https://www.erlang.org"
      }
    }
  end

  def enhance_metadata(app, _dependency) when is_hex_app(app) do
    %{
      licenses: ["Apache-2.0"],
      source_url: "git+https://github.com/hexpm/hex",
      links: %{
        "github" => "https://github.com/hexpm/hex",
        "website" => "https://hex.pm"
      }
    }
  end

  def enhance_metadata(_app, _dependency), do: %{}
end
