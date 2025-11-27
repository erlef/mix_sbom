# SPDX-License-Identifier: BSD-3-Clause
# SPDX-FileCopyrightText: 2019 Bram Verburg
# SPDX-FileCopyrightText: 2025 Erlang Ecosystem Foundation

defmodule SBoM.CLI do
  @moduledoc """
  Shared CLI logic for generating CycloneDX SBoMs.

  Used by both the Mix task and escript implementations.
  """

  alias SBoM.CycloneDX
  alias SBoM.Fetcher

  @version Mix.Project.config()[:version]

  @type cli_mode() :: :mix | :escript | :burrito
  @type format() :: :xml | :json | :protobuf
  @type schema_version() :: String.t()

  @schema_versions ~w[1.7 1.6 1.5 1.4 1.3]

  @default_path %{
    xml: "bom.cdx.xml",
    json: "bom.cdx.json",
    protobuf: "bom.cdx"
  }

  @default_format :json
  @default_schema "1.6"
  @default_classification :CLASSIFICATION_APPLICATION

  @spec run(OptionParser.argv(), cli_mode()) :: :ok
  def run(args, mode) do
    mode
    |> parse!(args)
    |> case do
      {[:cyclonedx], parse_result} ->
        parse_result
        |> put_default_path(mode)
        |> update_output_path_and_format()
        |> generate_bom_content()
    end
  catch
    :done -> :ok
  end

  @spec generate_bom_content(Optimus.ParseResult.t()) :: :ok
  defp generate_bom_content(parse_result) do
    case parse_result.args[:project_path] do
      nil ->
        generate_bom_content_in_project(parse_result)

      path ->
        SBoM.Util.in_project(path, fn _mix_project ->
          generate_bom_content_in_project(parse_result)
        end)
    end
  end

  @spec generate_bom_content_in_project(Optimus.ParseResult.t()) :: :ok
  defp generate_bom_content_in_project(parse_result)

  defp generate_bom_content_in_project(%Optimus.ParseResult{flags: %{recurse: true}} = parse_result) do
    Mix.Task.rerun("loadpaths", ["--no-deps-check"])

    Mix.Project.apps_paths()
    |> tap(fn
      nil ->
        Mix.raise("""
        --recurse option can only be used inside an umbrella project
        """)

      _other ->
        :ok
    end)
    |> Enum.each(fn {app, path} ->
      Mix.Project.in_project(app, path, fn _mix_project ->
        generate_bom_content_in_app(parse_result)
      end)
    end)
  end

  defp generate_bom_content_in_project(%Optimus.ParseResult{} = parse_result) do
    generate_bom_content_in_app(parse_result)
  end

  @spec generate_bom_content_in_app(Optimus.ParseResult.t()) :: :ok
  defp generate_bom_content_in_app(parse_result) do
    Fetcher.fetch()
    |> CycloneDX.bom(
      version: parse_result.options.schema,
      only: parse_result.options.only,
      targets: parse_result.options.targets,
      classification: parse_result.options.classification
    )
    |> CycloneDX.encode(parse_result.options.format)
    |> write_file(parse_result.options.output, parse_result.flags.force)
  end

  @spec write_file(iodata, Path.t(), boolean()) :: :ok
  defp write_file(content, output_path, force) do
    if Mix.Generator.create_file(output_path, content, force: force) do
      :ok
    else
      Mix.raise("Failed to write SBoM to #{output_path}.")
    end
  end

  @spec cli_def(cli_mode()) :: Optimus.t()
  def cli_def(mode) do
    Optimus.new!(
      name: "mix_sbom",
      description: "Mix SBoM",
      version: @version,
      author: "Erlang Ecosystem Foundation",
      about: "Software Bill of Materials (SBoM) for Elixir projects",
      allow_unknown_args: false,
      parse_double_dash: true,
      subcommands: [
        cyclonedx: [
          name: "cyclonedx",
          about: "Generate CycloneDX SBoM",
          args:
            case mode do
              :mix ->
                []

              mode when mode in [:escript, :burrito] ->
                [
                  project_path: [
                    value_name: "PROJECT_PATH",
                    help: "Path to the Mix project (defaults to current working directory)",
                    required: false,
                    default: &File.cwd!/0
                  ]
                ]
            end,
          options: [
            output: [
              value_name: "OUTPUT_PATH",
              short: "-o",
              long: "--output",
              help: "Path to write the generated SBoM to (defaults to bom.cdx.json)",
              required: false,
              parser: :string
            ],
            schema: [
              value_name: "SCHEMA_VERSION",
              short: "-s",
              long: "--schema",
              help: "CycloneDX schema version to use (defaults to 1.6)",
              required: false,
              parser: &parse_schema/1,
              default: @default_schema
            ],
            format: [
              value_name: "FORMAT",
              short: "-t",
              long: "--format",
              help: "Output format, one of xml, json, protobuf (defaults to json)",
              required: false,
              parser: &parse_format/1
            ],
            only: [
              value_name: "ONLY",
              short: "-l",
              long: "--only",
              help: "Only include components used in the specified environment",
              required: false,
              default: [:*],
              parser: &parse_atom/1,
              multiple: true
            ],
            targets: [
              value_name: "TARGETS",
              short: "-a",
              long: "--targets",
              help: "Comma-separated list of Mix targets to include components from (defaults to all targets)",
              required: false,
              default: [:*],
              parser: &parse_atom/1,
              multiple: true
            ],
            classification: [
              value_name: "CLASSIFICATION",
              short: "-c",
              long: "--classification",
              help: "Specifies the type of application being described (defaults to application)",
              required: false,
              default: @default_classification,
              parser: &parse_classification/1
            ]
          ],
          flags: [
            force: [
              short: "-f",
              long: "--force",
              help: "Overwrite existing output file if it exists"
            ],
            recurse: [
              short: "-r",
              long: "--recurse",
              help: "Recurse into umbrella applications to generate SBoM for all apps"
            ]
          ]
        ]
      ]
    )
  end

  @spec parse!(cli_mode(), OptionParser.argv()) ::
          {Optimus.subcommand_path(), Optimus.ParseResult.t()}
  defp parse!(mode, command_line) do
    optimus = cli_def(mode)

    case Optimus.parse(optimus, command_line) do
      {:ok, _parse_result} ->
        handle_response(
          mode,
          0,
          optimus_text_to_binary([
            "No subcommand provided.",
            "",
            Optimus.help(optimus)
          ])
        )

      {:ok, subcommand_path, parse_result} ->
        {subcommand_path, parse_result}

      {:error, errors} ->
        handle_response(
          mode,
          1,
          optimus |> Optimus.Errors.format(errors) |> optimus_text_to_binary()
        )

      {:error, subcommand_path, errors} ->
        handle_response(
          mode,
          1,
          optimus |> Optimus.Errors.format(subcommand_path, errors) |> optimus_text_to_binary()
        )

      :version ->
        handle_response(mode, 0, optimus |> Optimus.Title.title() |> optimus_text_to_binary())

      :help ->
        handle_response(
          mode,
          0,
          optimus |> Optimus.Help.help([], columns()) |> optimus_text_to_binary()
        )

      {:help, subcommand_path} ->
        handle_response(
          mode,
          0,
          optimus |> Optimus.Help.help(subcommand_path, columns()) |> optimus_text_to_binary()
        )
    end
  end

  @spec handle_response(cli_mode(), non_neg_integer(), String.t()) :: no_return()
  defp handle_response(mode, status_code, message)

  defp handle_response(:mix, 0, message) do
    Mix.shell().info(message)
    throw(:done)
  end

  defp handle_response(:mix, status_code, message) do
    Mix.raise(message, exit_status: status_code)
  end

  defp handle_response(_mode, status_code, message) do
    IO.write(:stderr, message)
    System.halt(status_code)
  end

  @spec optimus_text_to_binary(iodata) :: String.t()
  defp optimus_text_to_binary(text) do
    IO.iodata_to_binary(["\e[0m" | Enum.intersperse(text, "\n")])
  end

  @spec update_output_path_and_format(Optimus.ParseResult.t()) :: Optimus.ParseResult.t()
  defp update_output_path_and_format(%Optimus.ParseResult{} = parse_result) do
    {output, format} =
      case {parse_result.options[:output], parse_result.options[:format]} do
        {nil, nil} -> {@default_path.json, @default_format}
        {output, nil} -> {output, format_from_path(output)}
        {nil, format} -> {@default_path[format], format}
        {output, format} -> {output, format}
      end

    %{
      parse_result
      | options:
          Map.merge(parse_result.options, %{
            output: output,
            format: format
          })
    }
  end

  @spec columns() :: non_neg_integer()
  defp columns do
    case Optimus.Term.width() do
      {:ok, width} -> width
      _other -> 80
    end
  end

  @spec put_default_path(Optimus.ParseResult.t(), cli_mode()) :: Optimus.ParseResult.t()
  defp put_default_path(parse_result, mode)
  defp put_default_path(parse_result, :mix), do: parse_result

  defp put_default_path(%Optimus.ParseResult{} = parse_result, _mode) do
    Map.update!(parse_result, :args, fn args ->
      Map.put(args, :project_path, args[:project_path] || File.cwd!())
    end)
  end

  @spec format_from_path(Path.t()) :: format()
  defp format_from_path(path) do
    case Path.extname(path) do
      ".json" -> :json
      ".xml" -> :xml
      ".cdx" -> :protobuf
      _other_ext -> :json
    end
  end

  @spec parse_schema(String.t()) :: {:ok, schema_version()} | {:error, String.t()}
  defp parse_schema(schema)
  defp parse_schema(schema) when schema in @schema_versions, do: {:ok, schema}

  defp parse_schema(_other), do: {:error, "available versions are #{Enum.join(@schema_versions, ", ")}"}

  @spec parse_format(String.t()) :: {:ok, format()} | {:error, String.t()}
  defp parse_format(format)
  defp parse_format("xml"), do: {:ok, :xml}
  defp parse_format("json"), do: {:ok, :json}
  defp parse_format("protobuf"), do: {:ok, :protobuf}

  defp parse_format(_other), do: {:error, "available formats are xml, json, protobuf"}

  @spec parse_atom(String.t()) :: {:ok, atom()} | {:error, String.t()}
  # Since this runs once per CLI invocation, using String.to_atom is acceptable.
  # credo:disable-for-next-line Credo.Check.Warning.UnsafeToAtom
  defp parse_atom(value), do: {:ok, String.to_atom(value)}

  @classifications %{
    "application" => :CLASSIFICATION_APPLICATION,
    "framework" => :CLASSIFICATION_FRAMEWORK,
    "library" => :CLASSIFICATION_LIBRARY,
    "operating-system" => :CLASSIFICATION_OPERATING_SYSTEM,
    "device" => :CLASSIFICATION_DEVICE,
    "file" => :CLASSIFICATION_FILE,
    "container" => :CLASSIFICATION_CONTAINER,
    "firmware" => :CLASSIFICATION_FIRMWARE,
    "device-driver" => :CLASSIFICATION_DEVICE_DRIVER,
    "platform" => :CLASSIFICATION_PLATFORM,
    "machine-learning-model" => :CLASSIFICATION_MACHINE_LEARNING_MODEL,
    "data" => :CLASSIFICATION_DATA,
    "cryptographic-asset" => :CLASSIFICATION_CRYPTOGRAPHIC_ASSET
  }

  @spec parse_classification(String.t()) ::
          {:ok, CycloneDX.classification()} | {:error, String.t()}
  defp parse_classification(value) do
    value = String.downcase(value)

    case Map.fetch(@classifications, value) do
      {:ok, classification} ->
        {:ok, classification}

      :error ->
        {:error, "available classifications are #{Enum.join(Map.keys(@classifications), ", ")}"}
    end
  end
end
