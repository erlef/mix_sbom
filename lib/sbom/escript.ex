defmodule SBoM.Escript do
  @moduledoc """
  Escript entry point for generating CycloneDX SBoMs.
  """

  alias SBoM.CLI

  @spec main(OptionParser.argv()) :: :ok
  def main(args) do
    if "--help" in args or "-h" in args do
      print_help()
    else
      opts = CLI.parse_and_validate_opts(args, :escript)
      content = CLI.generate_bom_content(opts)
      force? = Keyword.get(opts, :force, false)

      if File.exists?(opts[:output]) and not force? do
        IO.write(
          :stderr,
          "Error: File #{opts[:output]} already exists. Use --force to overwrite.\n"
        )

        System.halt(1)
      end

      File.write!(opts[:output], content)
      IO.write(:stderr, "Generated SBoM: #{opts[:output]}\n")
    end
  end

  @spec print_help() :: :ok
  defp print_help do
    IO.write("""
    SBoM - Software Bill of Materials Generator

    Generates a Software Bill-of-Materials (SBoM) in CycloneDX format.

    USAGE:
        sbom [OPTIONS] [PATH]

    OPTIONS:
        -o, --output PATH        Output file path (default: bom.cdx.json)
        -f, --force              Overwrite existing files without prompting
        -d, --dev                Include dev dependencies (default: prod only)
        -s, --schema VERSION     CycloneDX schema version (default: 1.6)
                                 Available: 1.7, 1.6, 1.5, 1.4, 1.3
        -t, --format FORMAT      Output format: xml, json, protobuf (default: json)
        -c, --classification TYPE Project classification (default: application)
        -h, --help               Show this help message

    EXAMPLES:
        sbom                     Generate bom.cdx.json
        sbom -o my-bom.xml       Generate XML format
        sbom -f -t json          Force overwrite with JSON format
        sbom -s 1.7 -d           Use schema 1.7 with dev dependencies
    """)
  end
end
