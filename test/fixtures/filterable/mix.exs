defmodule Filterable.MixProject do
  use Mix.Project

  def project do
    [
      app: :filterable,
      version: "0.1.0",
      elixir: "~> 1.8",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      # No only/targets specified - should be included in all cases (default [:*])
      {:jason, "~> 1.1"},

      # Only development dependencies
      {:ex_doc, "~> 0.21.2", only: :dev},
      {:dialyxir, "~> 1.0", only: :dev},

      # Only test dependencies
      {:meck, "~> 0.8.13", only: :test},
      {:excoveralls, "~> 0.10", only: :test},

      # Only production dependencies
      {:hackney, "~> 1.15", only: :prod},

      # Multiple environments
      {:sweet_xml, "~> 0.6.6", only: [:dev, :test]},
      {:telemetry, "~> 0.4", only: [:prod, :dev]},

      # With targets (mix specific option)
      {:phoenix, "~> 1.5", targets: [:host]},
      {:nerves, "~> 1.6", targets: [:rpi]},

      # With both only and targets
      {:phoenix_live_dashboard, "~> 0.4", only: :dev, targets: [:host]},
      {:circuits_gpio, "~> 0.4", only: [:dev, :test], targets: [:rpi]},

      # Optional dependencies
      {:optional_dep, "~> 1.0", optional: true},
      {:optional_dev_dep, "~> 2.0", optional: true, only: :dev},

      # Runtime false (build-time only)
      {:mix_test_watch, "~> 1.0", only: :dev, runtime: false},

      # Complex combinations
      {:complex_dep, "~> 1.0", only: [:dev, :test], targets: [:host, :rpi], optional: true}
    ]
  end
end
