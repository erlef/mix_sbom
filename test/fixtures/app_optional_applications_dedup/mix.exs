defmodule AppNameToReplace.MixProject do
  use Mix.Project

  def project do
    [
      app: :app_name_to_replace,
      version: "0.0.0-dev",
      deps: []
    ]
  end

  # Mix accepts the optional tuple in `:applications` too. Listing the same
  # app in both keys must still yield one component.
  def application do
    [
      applications: [observer: :optional],
      extra_applications: [:logger, tools: :optional, observer: :optional]
    ]
  end
end
