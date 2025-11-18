defmodule Mix.Tasks.Sbom.Cyclonedx do
  @shortdoc "Generates CycloneDX SBoM"

  @moduledoc """
  Generates a Software Bill-of-Materials (SBoM) in CycloneDX format.

  ## Options

    * `--output` (`-o`): the full path to the SBoM output file (default: bom.cdx.json)
    * `--force` (`-f`): overwrite existing files without prompting for confirmation
    * `--dev` (`-d`): include dependencies for non-production environments
      (including `dev`, `test` or `docs`); by default only dependencies for MIX_ENV=prod are returned
    * `--recurse` (`-r`): in an umbrella project, generate individual output
      files for each application, rather than a single file for the entire project
    * `--schema` (`-s`): schema version to be used, defaults to "1.6"
    * `--format` (`-t`): output format: xml, json, or protobuf; defaults to "json"
    * `--classification` (`-c`): the project classification, e.g. "application",
      "library", "framework"; defaults to "application"

  """

  use Mix.Task

  import Mix.Generator

  alias SBoM.CLI

  @doc false
  @impl Mix.Task
  def run(all_args) do
    opts = CLI.parse_and_validate_opts(all_args, :mix)

    output_path = opts[:output]
    environment = (!opts[:dev] && :prod) || nil
    apps = Mix.Project.apps_paths()

    if opts[:recurse] && apps do
      Enum.each(apps, &generate_bom(&1, output_path, environment, opts[:force]))
    else
      generate_bom(output_path, environment, opts)
    end
  end

  defp generate_bom(output_path, _environment, opts) do
    bom = CLI.generate_bom_content(opts)
    create_file(output_path, bom, force: opts[:force])
  end

  defp generate_bom({app, path}, output_path, environment, force) do
    Mix.Project.in_project(app, path, fn _module ->
      generate_bom(output_path, environment, %{force: force})
    end)
  end
end
