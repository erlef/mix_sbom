defmodule SBoM.CLI do
  @moduledoc """
  Shared CLI logic for generating CycloneDX SBoMs.

  Used by both the Mix task and escript implementations.
  """

  alias SBoM.CycloneDX
  alias SBoM.Fetcher

  @type cli_mode() :: :mix | :escript | :burrito
  @type cli_opts() :: [
          output: Path.t(),
          force: boolean(),
          dev: boolean(),
          recurse: boolean(),
          schema: schema_version(),
          format: format(),
          classification: String.t(),
          path: Path.t(),
          help: boolean()
        ]
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
  @default_classification "application"

  @default_opts [
    schema: @default_schema,
    classification: @default_classification
  ]

  @spec parse_and_validate_opts(OptionParser.argv(), cli_mode()) :: cli_opts()
  def parse_and_validate_opts(args, mode) do
    {opts, args} = parse_opts(args, mode)

    opts =
      case {args, mode} do
        {[_first_arg | _remaining_args], :mix} ->
          raise "too many arguments provided"

        {[], :mix} ->
          opts

        {[_first_arg, _second_arg | _remaining_args], :escript} ->
          raise "too many arguments provided"

        {[path], mode} when mode in [:escript, :burrito] ->
          Keyword.put(opts, :path, path)

        {[], mode} when mode in [:escript, :burrito] ->
          Keyword.put(opts, :path, File.cwd!())
      end

    opts
    |> Keyword.merge(@default_opts, fn _k, v1, _v2 -> v1 end)
    |> update_output_path_and_format!()
    |> tap(&validate_schema!(&1[:schema]))
  end

  @spec generate_bom_content(cli_opts()) :: iodata()
  def generate_bom_content(opts) do
    case Keyword.fetch(opts, :path) do
      {:ok, path} ->
        SBoM.Util.in_project(path, fn _mix_project ->
          _generate_bom_content(opts)
        end)

      :error ->
        _generate_bom_content(opts)
    end
  end

  @spec _generate_bom_content(cli_opts()) :: iodata()
  defp _generate_bom_content(opts) do
    Fetcher.fetch()
    |> CycloneDX.bom(CycloneDX.empty(opts[:schema]))
    |> CycloneDX.encode(opts[:format])
  end

  @spec parse_opts(OptionParser.argv(), cli_mode()) :: {cli_opts(), OptionParser.argv()}
  defp parse_opts(args, :mix) do
    {_opts, []} =
      OptionParser.parse!(args,
        aliases: [
          o: :output,
          f: :force,
          d: :dev,
          r: :recurse,
          s: :schema,
          t: :format,
          c: :classification
        ],
        strict: [
          output: :string,
          force: :boolean,
          dev: :boolean,
          recurse: :boolean,
          schema: :string,
          format: :string,
          classification: :string
        ]
      )
  end

  defp parse_opts(args, mode) when mode in [:escript, :burrito] do
    OptionParser.parse!(args,
      aliases: [
        o: :output,
        f: :force,
        d: :dev,
        s: :schema,
        t: :format,
        c: :classification,
        h: :help
      ],
      strict: [
        output: :string,
        force: :boolean,
        dev: :boolean,
        schema: :string,
        format: :string,
        classification: :string,
        help: :boolean
      ]
    )
  end

  @spec update_output_path_and_format!(cli_opts()) :: cli_opts()
  defp update_output_path_and_format!(opts) do
    {output, format} =
      case {opts[:output], opts[:format]} do
        {nil, nil} ->
          {@default_path.json, @default_format}

        {output, nil} ->
          {output, format_from_path(output)}

        {nil, "xml"} ->
          {@default_path.xml, :xml}

        {nil, "json"} ->
          {@default_path.json, :json}

        {nil, "protobuf"} ->
          {@default_path.protobuf, :protobuf}

        {output, format} when format in ["xml", "json", "protobuf"] ->
          {output, String.to_existing_atom(format)}
      end

    Keyword.merge(opts, output: output, format: format)
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

  @spec validate_schema!(schema_version()) :: true
  defp validate_schema!(schema) do
    schema in @schema_versions ||
      Mix.raise("invalid cyclonedx schema version, available versions are #{Enum.join(@schema_versions, ", ")}")
  end
end
