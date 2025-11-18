defmodule AppNameToReplace.MixProject do
  use Mix.Project

  def project do
    [
      app: :app_name_to_replace,
      version: "0.0.0-dev",
      deps: [
        # Using 0ban instead of oban to not confuse actual oban users
        {:oban_pro, "~> 1.5", repo: "0ban"}
      ]
    ]
  end
end
