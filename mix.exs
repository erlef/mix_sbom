# SPDX-License-Identifier: BSD-3-Clause
# SPDX-FileCopyrightText: 2019 Bram Verburg
# SPDX-FileCopyrightText: 2025 Erlang Ecosystem Foundation
# SPDX-FileCopyrightText: 2025 Stritzinger GmbH

defmodule SBoM.MixProject do
  use Mix.Project

  @version "0.8.0"
  @source_url "https://github.com/erlef/mix_sbom"

  def project do
    [
      app: :sbom,
      version: @version,
      # MIX.SCM.delete available from 1.16.2
      elixir: "~> 1.16 and >= 1.16.2",
      start_permanent: Mix.env() == :prod,
      build_embedded: true,
      elixirc_paths: elixirc_paths(Mix.env()),
      deps: deps(),
      archives: archives(),
      name: "SBoM",
      description: description(),
      package: package(),
      docs: docs(),
      aliases: aliases(),
      releases: releases(),
      escript: escript(),
      source_url: @source_url,
      test_ignore_filters: [~r/test\/fixtures/],
      test_coverage: [
        tool: ExCoveralls
      ],
      lockfile: if(enable_burrito?(), do: "mix.lock.burrito", else: "mix.lock")
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      mod: {SBoM.Application, []},
      extra_applications: [:mix, :xmerl, :logger],
      included_applications: [:hex]
    ]
  end

  def cli do
    [
      preferred_envs: [
        test_property: :test,
        coveralls: :test,
        "coveralls.detail": :test,
        "coveralls.html": :test,
        "coveralls.json": :test,
        "coveralls.post": :test,
        "coveralls.xml": :test
      ]
    ]
  end

  defp escript do
    [
      main_module: SBoM.Escript,
      name: "mix_sbom"
    ]
  end

  defp releases do
    [
      mix_sbom: [
        steps: [:assemble, &check_burrito_presence/1, &Burrito.wrap/1],
        burrito: [
          targets: [
            Linux_X64: [os: :linux, cpu: :x86_64],
            Linux_ARM64: [os: :linux, cpu: :aarch64],
            macOS_X64: [os: :darwin, cpu: :x86_64],
            macOS_ARM64: [os: :darwin, cpu: :aarch64],
            Windows_X64: [os: :windows, cpu: :x86_64]
            # Not currently supported by Burrito
            # Windows_ARM64: [os: :windows, cpu: :aarch64]
          ]
        ]
      ]
    ]
  end

  defp aliases do
    [
      test_property: "test --exclude test --include property"
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_env), do: ["lib"]

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    # styler:sort
    Enum.reject(
      [
        if(enable_burrito?(), do: {:burrito, "~> 1.0"}),
        {:credo, "~> 1.0", only: [:dev], runtime: false},
        {:dialyxir, "~> 1.0", only: [:dev], runtime: false},
        {:doctest_formatter, "~> 0.4.0", only: [:dev, :test], runtime: false},
        {:ex_doc, ">= 0.0.0", only: [:dev], runtime: false},
        {:excoveralls, "~> 0.5", only: [:test], runtime: false},
        {:hex_core, "~> 0.12.0"},
        {:jason, "~> 1.4", optional: true},
        {:optimus, "~> 0.5.1"},
        {:protobuf, "~> 0.15.0"},
        {:purl, "~> 0.3.0"},
        {:stream_data, "~> 1.2", only: [:test]},
        {:styler, "~> 1.1", only: [:dev, :test], runtime: false}
      ],
      &is_nil/1
    )
  end

  defp archives do
    [
      {:hex, "~> 2.3"}
    ]
  end

  defp description do
    "Mix task to generate a Software Bill-of-Materials (SBoM) in CycloneDX format"
  end

  defp package do
    [
      maintainers: ["Erlang Ecosystem Foundation"],
      links: %{
        "GitHub" => @source_url,
        "Releases" => @source_url <> "/releases",
        "Issues" => @source_url <> "/issues"
      },
      licenses: [
        # Main License
        "BSD-3-Clause",
        # Generated Code
        "CC0-1.0",
        # Appropriated Code from protobuf libary in
        # lib/sbom/cyclonedx/json/encoder.ex
        "MIT",
        "Apache-2.0"
      ]
    ]
  end

  defp docs do
    [
      main: "SBoM",
      source_ref: "v#{@version}",
      nest_modules_by_prefix: [
        SBoM.CycloneDX.V13,
        SBoM.CycloneDX.V14,
        SBoM.CycloneDX.V15,
        SBoM.CycloneDX.V16,
        SBoM.CycloneDX.V17
      ]
    ]
  end

  defp check_burrito_presence(release) do
    if not enable_burrito?() do
      Mix.raise("""
      Burrito packaging is not enabled.
      To enable it, set the environment variable MIX_ENABLE_BURRITO to "1".
      """)
    end

    release
  end

  defp enable_burrito?, do: System.get_env("MIX_ENABLE_BURRITO") in ["1", "true", "TRUE", "y", "Y", "yes", "YES"]
end
