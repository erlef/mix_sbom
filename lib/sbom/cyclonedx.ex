# SPDX-License-Identifier: BSD-3-Clause
# SPDX-FileCopyrightText: 2025 Erlang Ecosystem Foundation

defmodule SBoM.CycloneDX do
  @moduledoc false

  @type t() ::
          SBoM.Cyclonedx.V13.Bom.t()
          | SBoM.Cyclonedx.V14.Bom.t()
          | SBoM.Cyclonedx.V15.Bom.t()
          | SBoM.Cyclonedx.V16.Bom.t()
          | SBoM.Cyclonedx.V17.Bom.t()
  @type components_map() :: %{SBoM.Fetcher.app_name() => SBoM.Fetcher.dependency()}
  @type component() ::
          SBoM.Cyclonedx.V13.Component.t()
          | SBoM.Cyclonedx.V14.Component.t()
          | SBoM.Cyclonedx.V15.Component.t()
          | SBoM.Cyclonedx.V16.Component.t()
          | SBoM.Cyclonedx.V17.Component.t()
  @type classification() ::
          SBoM.Cyclonedx.V13.Classification.t()
          | SBoM.Cyclonedx.V14.Classification.t()
          | SBoM.Cyclonedx.V15.Classification.t()
          | SBoM.Cyclonedx.V16.Classification.t()
          | SBoM.Cyclonedx.V17.Classification.t()
  @type dependency_list() :: [
          SBoM.Cyclonedx.V13.Dependency.t()
          | SBoM.Cyclonedx.V14.Dependency.t()
          | SBoM.Cyclonedx.V15.Dependency.t()
          | SBoM.Cyclonedx.V16.Dependency.t()
          | SBoM.Cyclonedx.V17.Dependency.t()
        ]
  @type license_list() :: [
          SBoM.Cyclonedx.V13.LicenseChoice.t()
          | SBoM.Cyclonedx.V14.LicenseChoice.t()
          | SBoM.Cyclonedx.V15.LicenseChoice.t()
          | SBoM.Cyclonedx.V16.LicenseChoice.t()
          | SBoM.Cyclonedx.V17.LicenseChoice.t()
        ]
  @type scope() ::
          SBoM.Cyclonedx.V13.Scope.t()
          | SBoM.Cyclonedx.V14.Scope.t()
          | SBoM.Cyclonedx.V15.Scope.t()
          | SBoM.Cyclonedx.V16.Scope.t()
          | SBoM.Cyclonedx.V17.Scope.t()
  @type metadata() ::
          SBoM.Cyclonedx.V13.Metadata.t()
          | SBoM.Cyclonedx.V14.Metadata.t()
          | SBoM.Cyclonedx.V15.Metadata.t()
          | SBoM.Cyclonedx.V16.Metadata.t()
          | SBoM.Cyclonedx.V17.Metadata.t()
  @type tool() ::
          SBoM.Cyclonedx.V13.Tool.t()
          | SBoM.Cyclonedx.V14.Tool.t()
          | SBoM.Cyclonedx.V15.Tool.t()
          | SBoM.Cyclonedx.V16.Tool.t()
          | SBoM.Cyclonedx.V17.Tool.t()
  @type external_reference() ::
          SBoM.Cyclonedx.V13.ExternalReference.t()
          | SBoM.Cyclonedx.V14.ExternalReference.t()
          | SBoM.Cyclonedx.V15.ExternalReference.t()
          | SBoM.Cyclonedx.V16.ExternalReference.t()
          | SBoM.Cyclonedx.V17.ExternalReference.t()
  @type uuid() :: <<_::288>>

  @version Mix.Project.config()[:version]

  json_available =
    case {Code.ensure_loaded(JSON), Code.ensure_loaded(Jason)} do
      {{:module, JSON}, _jason} ->
        @json_module JSON
        true

      {_json, {:module, Jason}} ->
        @json_module Jason
        true

      {{:error, _json_error}, {:error, _jason_error}} ->
        @json_module nil
        false
    end

  @utf8_bom <<0xEF, 0xBB, 0xBF>>
  @xml_prolog ~c"<?xml version=\"1.0\" encoding=\"utf-8\"?>"

  @pretty_json_error """
  Pretty JSON formatting is not available.

  Options:
  1. Update to a newer version of Erlang/OTP that includes :json.format/2
  2. Use Jason for JSON encoding (add {:jason, "~> 1.4"} to your dependencies)
  3. Disable pretty printing (set pretty: false)
  """

  @spec empty(SBoM.CLI.schema_version()) :: t()
  def empty(version \\ "1.7") do
    bom_struct(:Bom, version,
      spec_version: version,
      serial_number: urn_uuid(),
      version: 0,
      metadata: bom_struct(:Metadata, version)
    )
  end

  @type bom_opts() :: [
          starting_bom: t(),
          serial: String.t(),
          version: String.t(),
          only: [atom()],
          targets: [atom()],
          classification: classification()
        ]

  @spec bom(components_map(), bom_opts()) :: t()
  def bom(components, opts \\ []) do
    version = Keyword.get(opts, :version, "1.7")
    starting_bom = Keyword.get(opts, :starting_bom, empty(version))
    serial = Keyword.get(opts, :serial, urn_uuid())
    only = Keyword.get(opts, :only, [:*])
    targets = Keyword.get(opts, :targets, [:*])
    classification = Keyword.get(opts, :classification, :CLASSIFICATION_APPLICATION)

    %{spec_version: version} = starting_bom

    filtered_components = filter_components(components, only, targets)
    bom_components = attach_components(filtered_components, version)

    starting_bom
    |> Map.put(:serial_number, serial)
    |> Map.update!(:version, &(&1 + 1))
    |> Map.update!(:metadata, &attach_metadata(&1, version, filtered_components, classification))
    |> Map.put(:components, bom_components)
    |> Map.put(:dependencies, attach_dependencies(filtered_components, version))
  end

  @spec encode(t(), SBoM.CLI.format(), SBoM.CLI.pretty()) :: iodata()
  def encode(bom, type, pretty \\ false)

  def encode(%module{} = bom, :protobuf, _pretty), do: module.encode(bom)

  if json_available do
    def encode(bom, :json, pretty) do
      alias SBoM.CycloneDX.JSON.Encodable

      bom
      |> Encodable.to_encodable()
      |> encode_json(pretty)
    end
  else
    def encode(_bom, :json, _pretty) do
      raise """
      JSON encoding is not available. Please either update to Elixir 1.18+ or add
      {:jason, "~> 1.4"} to your dependencies.
      """
    end
  end

  def encode(bom, :xml, pretty) do
    alias SBoM.CycloneDX.XML.Encodable

    bom
    |> Encodable.to_xml_element()
    |> encode_xml(pretty)
  end

  @spec attach_metadata(metadata(), SBoM.CLI.schema_version(), components_map(), classification()) ::
          metadata()
  defp attach_metadata(metadata, version, components, classification)

  defp attach_metadata(metadata, version, components, classification) when version in ["1.3", "1.4"] do
    metadata
    |> Map.put(:timestamp, timestamp_now())
    |> Map.update!(:tools, fn tools ->
      tools
      |> List.wrap()
      |> Enum.reject(&match?(%{name: "Mix SBoM", vendor: "Erlang Ecosystem Foundation"}, &1))
      |> then(&[tool(version) | &1])
    end)
    |> Map.put(:component, root_component(components, version, classification))
  end

  defp attach_metadata(metadata, version, components, classification) do
    metadata
    |> Map.put(:timestamp, timestamp_now())
    |> Map.update!(:tools, fn tools ->
      tools = tools || bom_struct(:Tool, version)

      components =
        tools.components
        |> List.wrap()
        |> Enum.reject(&match?(%{name: "Mix SBoM", supplier: %{name: "Erlang Ecosystem Foundation"}}, &1))
        |> then(&[tool(version) | &1])

      %{tools | components: components}
    end)
    |> Map.put(:component, root_component(components, version, classification))
  end

  @spec timestamp_now() :: Google.Protobuf.Timestamp.t()
  defp timestamp_now, do: DateTime.utc_now() |> DateTime.truncate(:second) |> Google.Protobuf.from_datetime()

  @spec root_component(components_map(), SBoM.CLI.schema_version(), classification()) ::
          {SBoM.Fetcher.app_name(), SBoM.Fetcher.dependency()} | nil
  def root_component(components, version, classification) do
    components
    |> Enum.find(&match?({_name, %{root: true}}, &1))
    |> case do
      nil ->
        nil

      {name, component} ->
        root_comp = convert_component(name, component, version)
        %{root_comp | type: classification}
    end
  end

  @spec env_overlaps?(:* | [:* | atom()], :* | [:* | atom()]) :: boolean()
  defp env_overlaps?(filter_env, component_env) do
    filter_set = filter_env |> List.wrap() |> MapSet.new()
    component_set = component_env |> List.wrap() |> MapSet.new()

    MapSet.member?(filter_set, :*) or MapSet.member?(component_set, :*) or
      not MapSet.disjoint?(filter_set, component_set)
  end

  @spec filter_components(components_map(), [atom()], [atom()]) :: components_map()
  defp filter_components(components, only, targets) do
    components
    |> Enum.filter(fn {_name, component} ->
      component_only = Map.get(component, :only, [:*])
      component_targets = Map.get(component, :targets, [:*])

      env_overlaps?(only, component_only) and env_overlaps?(targets, component_targets)
    end)
    |> Map.new()
  end

  @spec attach_components(components_map(), SBoM.CLI.schema_version()) :: [component()]
  defp attach_components(components, version) do
    Enum.flat_map(components, fn
      {_name, %{root: true}} ->
        []

      {name, component_data} ->
        [convert_component(name, component_data, version)]
    end)
  end

  @spec convert_component(
          SBoM.Fetcher.app_name(),
          SBoM.Fetcher.dependency(),
          SBoM.CLI.schema_version()
        ) :: struct()
  defp convert_component(name, component, schema_version) do
    purl_string = to_string(component.package_url)

    source_url_reference =
      case component[:source_url] do
        nil -> nil
        source_url -> source_url_reference(source_url, schema_version)
      end

    asset_reference = asset_reference(component, schema_version)

    bom_struct(:Component, schema_version,
      type: :CLASSIFICATION_LIBRARY,
      name: name,
      version:
        case schema_version do
          "1.3" -> component[:version] || component[:version_requirement] || "unknown"
          # TODO: Handle VersionRequirement separately in 1.7+
          _schema_version -> component[:version] || component[:version_requirement]
        end,
      purl: purl_string,
      scope: dependency_scope(component),
      licenses: component[:licenses] |> List.wrap() |> convert_licenses(schema_version),
      bom_ref: generate_bom_ref(purl_string),
      external_references:
        Enum.reject(
          [
            source_url_reference,
            asset_reference | links_references(component[:links] || %{}, schema_version)
          ],
          &is_nil/1
        )
    )
  end

  @spec source_url_reference(
          source_url :: String.t(),
          SBoM.CLI.schema_version()
        ) :: external_reference()
  defp source_url_reference(source_url, version) do
    bom_struct(:ExternalReference, version,
      type: :EXTERNAL_REFERENCE_TYPE_VCS,
      url: source_url
    )
  end

  @spec asset_reference(
          component :: SBoM.Fetcher.dependency(),
          SBoM.CLI.schema_version()
        ) :: external_reference() | nil
  defp asset_reference(component, version)

  defp asset_reference(
         %{package_url: %Purl{type: "hex", qualifiers: %{"download_url" => download_url} = qualifiers}},
         version
       ) do
    bom_struct(:ExternalReference, version,
      type: :EXTERNAL_REFERENCE_TYPE_DISTRIBUTION,
      url: download_url,
      hashes:
        (
          %{"checksum" => "sha256:" <> hash} = qualifiers

          :Hash
          |> bom_struct(version,
            alg: :HASH_ALG_SHA_256,
            value: hash
          )
          |> List.wrap()
        )
    )
  end

  defp asset_reference(_component, _version), do: nil

  @spec links_references(
          links :: %{optional(String.t()) => String.t()},
          SBoM.CLI.schema_version()
        ) :: [external_reference()]
  defp links_references(links, version) do
    Enum.map(links, fn {name, url} ->
      type =
        case String.downcase(name) do
          source
          when source in ["github", "gitlab", "git", "source", "repository", "bitbucket"] ->
            :EXTERNAL_REFERENCE_TYPE_VCS

          chat when chat in ["chat", "slack", "discord", "gitter"] ->
            :EXTERNAL_REFERENCE_TYPE_CHAT

          support when support in ["support", "forum"] ->
            :EXTERNAL_REFERENCE_TYPE_SUPPORT

          website when website in ["website", "home", "homepage"] ->
            :EXTERNAL_REFERENCE_TYPE_WEBSITE

          issue_tracker when issue_tracker in ["issues", "issue_tracker", "bug_tracker"] ->
            :EXTERNAL_REFERENCE_TYPE_ISSUE_TRACKER

          documentation
          when documentation in ["docs", "documentation", "changelog", "contributing"] ->
            :EXTERNAL_REFERENCE_TYPE_DOCUMENTATION

          _other ->
            :EXTERNAL_REFERENCE_TYPE_OTHER
        end

      bom_struct(:ExternalReference, version,
        type: type,
        url: url,
        comment: name
      )
    end)
  end

  @spec dependency_scope(SBoM.Fetcher.dependency()) :: scope()
  defp dependency_scope(dependency) do
    optional? = Map.get(dependency, :optional, false)

    prod? =
      case Map.get(dependency, :only, []) do
        :* -> true
        only -> :prod in List.wrap(only)
      end

    cond do
      optional? ->
        :SCOPE_OPTIONAL

      prod? ->
        :SCOPE_REQUIRED

      true ->
        :SCOPE_EXCLUDED
    end
  end

  @spec convert_licenses([String.t()], SBoM.CLI.schema_version()) :: license_list()
  defp convert_licenses(licenses, version) do
    Enum.map(
      licenses,
      &bom_struct(:LicenseChoice, version, choice: {:license, bom_struct(:License, version, license: {:id, &1})})
    )
  end

  @spec attach_dependencies(components_map(), SBoM.CLI.schema_version()) :: dependency_list()
  defp attach_dependencies(components, version) do
    for {_name, component_data} <- components do
      purl_string = to_string(component_data.package_url)

      dependency_refs =
        component_data.dependencies
        |> List.wrap()
        |> Enum.map(fn dep_purl ->
          bom_struct(:Dependency, version, ref: generate_bom_ref(to_string(dep_purl)))
        end)

      bom_struct(:Dependency, version,
        ref: generate_bom_ref(purl_string),
        dependencies: dependency_refs
      )
    end
  end

  @spec generate_bom_ref(String.t()) :: String.t()
  defp generate_bom_ref(purl) when is_binary(purl) do
    hash = :erlang.phash2(purl)
    "urn:otp:component:#{hash}"
  end

  @spec tool(SBoM.CLI.schema_version()) :: tool() | component()
  defp tool(version)

  defp tool(version) when version in ["1.3", "1.4"] do
    bom_struct(:Tool, version,
      vendor: "Erlang Ecosystem Foundation",
      name: "Mix SBoM",
      version: @version
    )
  end

  defp tool(version) do
    bom_struct(:Component, version,
      type: :CLASSIFICATION_APPLICATION,
      supplier: bom_struct(:OrganizationalEntity, version, name: "Erlang Ecosystem Foundation"),
      name: "Mix SBoM",
      version: @version,
      scope: :SCOPE_EXCLUDED
    )
  end

  @spec urn_uuid() :: String.t()
  defp urn_uuid, do: "urn:uuid:#{uuid()}"

  @spec uuid() :: uuid()
  defp uuid do
    Enum.map_join(
      [
        :crypto.strong_rand_bytes(4),
        :crypto.strong_rand_bytes(2),
        <<4::4, :crypto.strong_rand_bytes(2)::binary-size(12)-unit(1)>>,
        <<2::2, :crypto.strong_rand_bytes(2)::binary-size(14)-unit(1)>>,
        :crypto.strong_rand_bytes(6)
      ],
      "-",
      &Base.encode16(&1, case: :lower)
    )
  end

  @spec bom_struct(module(), SBoM.CLI.schema_version(), Keyword.t()) :: struct()
  defp bom_struct(module, version, attrs \\ [])

  for {schema_version, prefix} <- %{
        "1.7" => SBoM.Cyclonedx.V17,
        "1.6" => SBoM.Cyclonedx.V16,
        "1.5" => SBoM.Cyclonedx.V15,
        "1.4" => SBoM.Cyclonedx.V14,
        "1.3" => SBoM.Cyclonedx.V13
      } do
    # Safe: Module.concat is called at compile time with well-known module names from a fixed map
    # credo:disable-for-next-line Credo.Check.Warning.UnsafeToAtom
    defp bom_struct(module, unquote(schema_version), attrs), do: struct(Module.concat([unquote(prefix), module]), attrs)
  end

  @spec encode_json(map(), boolean()) :: binary()
  if @json_module == Jason do
    defp encode_json(encodable, pretty) do
      if pretty do
        Jason.encode!(encodable, pretty: true)
      else
        Jason.encode!(encodable)
      end
    end
  else
    defp encode_json(encodable, pretty) do
      if pretty do
        encode_json_pretty(encodable)
      else
        JSON.encode!(encodable)
      end
    end

    @spec encode_json_pretty(term()) :: binary()
    defp encode_json_pretty(encodable) do
      case Code.ensure_loaded(:json) do
        {:module, :json} ->
          formatter = fn
            nil, _enc, _state -> <<"null">>
            other, enc, state -> :json.format_value(other, enc, state)
          end

          try do
            encodable
            |> :json.format(formatter)
            |> IO.iodata_to_binary()
          rescue
            e in UndefinedFunctionError ->
              if e.module == :json and e.function == :format and e.arity == 2 do
                error_msg =
                  "The JSON module is available, but :json.format/2 could not be called. " <>
                    "This function was introduced in a later version of the :json module.\n\n" <>
                    @pretty_json_error

                reraise RuntimeError.exception(error_msg), __STACKTRACE__
              else
                reraise e, __STACKTRACE__
              end
          end

        {:error, _reason} ->
          error_msg =
            "The JSON module is available, but the native :json Erlang module is not loaded.\n\n" <>
              @pretty_json_error

          raise RuntimeError, error_msg
      end
    end
  end

  @spec encode_xml(term(), boolean()) :: iodata()
  defp encode_xml(xml_element, pretty) do
    xml_element
    |> List.wrap()
    |> :xmerl.export_simple(xml_callback(pretty), prolog: @xml_prolog)
    |> IO.iodata_to_binary()
    |> then(&(@utf8_bom <> &1))
  end

  @spec xml_callback(boolean()) :: module()
  defp xml_callback(true), do: :xmerl_xml_indent
  defp xml_callback(false), do: :xmerl_xml
end
