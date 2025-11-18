defmodule AppNameToReplace.MixProject do
  use Mix.Project

  def project do
    [
      app: :app_name_to_replace,
      version: "0.0.0-dev",
      deps: [
        {:credo, "~> 1.7"},
        {:path_dep, path: "/tmp"},
        {:expo, github: "elixir-gettext/expo"},
        {:ueberauth_oidcc, git: "https://gitlab.com/paulswartz/ueberauth_oidcc.git"}
      ],
      package: [
        licenses: ["Apache-2.0"]
      ]
    ]
  end
end
