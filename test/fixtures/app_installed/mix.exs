defmodule AppNameToReplace.MixProject do
  use Mix.Project

  def project do
    [
      app: :app_name_to_replace,
      version: "0.0.0-dev",
      description: "A test application with installed dependencies",
      deps: [
        {:number, "~> 1.0"}
      ]
    ]
  end
end
