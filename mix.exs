defmodule SBoM.MixProject do
  use Mix.Project

  @version "0.7.0"
  @source_url "https://github.com/erlef/mix_sbom"

  def project do
    [
      app: :sbom,
      version: @version,
      elixir: "~> 1.7",
      start_permanent: Mix.env() == :prod,
      build_embedded: true,
      elixirc_paths: elixirc_paths(Mix.env()),
      deps: deps(),
      archives: archives(),
      name: "SBoM",
      description: description(),
      package: package(),
      docs: docs(),
      releases: releases(),
      escript: escript(),
      source_url: @source_url,
      test_ignore_filters: [~r/test\/fixtures/]
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
      default_target: :local,
      preferred_targets: [
        release: :standalone,
        # TODO: Remove once https://github.com/elixir-lang/elixir/issues/14930 is resolved
        "escript.build": :escript
      ]
    ]
  end

  defp escript do
    [
      main_module: SBoM.Escript
    ]
  end

  defp releases do
    [
      sbom: [
        steps: [:assemble, &Burrito.wrap/1],
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

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_env), do: ["lib"]

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    # styler:sort
    [
      {:burrito, "~> 1.0", targets: [:standalone]},
      {:credo, "~> 1.0", only: [:dev], runtime: false},
      {:dialyxir, "~> 1.0", only: [:dev], runtime: false},
      {:doctest_formatter, "~> 0.4.0", only: [:dev, :test], runtime: false},
      {:ex_doc, ">= 0.0.0", only: [:dev], runtime: false},
      {:excoveralls, "~> 0.5", only: [:test], runtime: false},
      # TODO: Remove once https://github.com/elixir-lang/elixir/issues/14930 is resolved
      {:hex, github: "hexpm/hex", tag: "v2.3.1", runtime: false, targets: [:escript]},
      {:protobuf, "~> 0.15.0"},
      {:purl, "~> 0.3.0"},
      {:styler, "~> 1.1", only: [:dev, :test], runtime: false}
    ]
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
      licenses: ["BSD-3-Clause"],
      links: %{"GitHub" => @source_url}
    ]
  end

  defp docs do
    [
      main: "readme",
      extras: ["README.md"],
      source_ref: "v#{@version}"
    ]
  end
end
