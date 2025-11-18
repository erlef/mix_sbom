defmodule AppNameToReplace.MixProject do
  use Mix.Project

  def project do
    [
      app: :app_name_to_replace,
      version: "0.0.0-dev",
      elixir: "1.18.4",
      deps: [
        {:credo, "~> 1.7"},
        {:mime, "~> 2.0"},
        {:expo, github: "elixir-gettext/expo"},
        {:heroicons,
         github: "tailwindlabs/heroicons", tag: "v2.1.5", sparse: "optimized", app: false, compile: false, depth: 1}
      ]
    ]
  end

  def application do
    [
      extra_applications: [:logger, :public_key, :os_mon]
    ]
  end
end
