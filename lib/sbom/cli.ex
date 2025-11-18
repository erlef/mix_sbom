defmodule SBoM.CLI do
  @moduledoc """
  Shared CLI logic for generating CycloneDX SBoMs.

  Used by both the Mix task and escript implementations.
  """

  alias SBoM.CycloneDX
  alias SBoM.Fetcher

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

  def parse_and_validate_opts(args, mode) do
    {opts, args} = parse_opts(args, mode)

    opts =
      case {args, mode} do
        {[_ | _], :mix} ->
          raise "too many arguments provided"

        {[], :mix} ->
          opts

        {[_, _ | _], :escript} ->
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

  defp _generate_bom_content(opts) do
    Fetcher.fetch()
    |> CycloneDX.bom(CycloneDX.empty(opts[:schema]))
    |> CycloneDX.encode(opts[:format])
  end

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

  defp format_from_path(path) do
    case Path.extname(path) do
      ".json" -> :json
      ".xml" -> :xml
      ".cdx" -> :protobuf
      _ -> :json
    end
  end

  defp validate_schema!(schema) do
    schema in @schema_versions ||
      raise "invalid cyclonedx schema version, available versions are #{Enum.join(@schema_versions, ", ")}"
  end
end
