defmodule AppNameToReplace.MixProject do
  use Mix.Project

  def project do
    [
      app: :app_name_to_replace,
      version: "0.0.0-dev",
      deps: []
    ]
  end

  def application do
    [
      extra_applications: [:logger, tools: :optional]
    ]
  end
end
