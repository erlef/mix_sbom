# SPDX-License-Identifier: BSD-3-Clause
# SPDX-FileCopyrightText: 2025 Erlang Ecosystem Foundation

defmodule SBoM.CycloneDX do
  @moduledoc false

  alias SBoM.CycloneDX.JSON
  alias SBoM.CycloneDX.Protobuf
  alias SBoM.CycloneDX.XML

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
  def encode(bom, :protobuf, _pretty), do: Protobuf.encode(bom)
  def encode(bom, :json, pretty), do: JSON.encode(bom, pretty)
  def encode(bom, :xml, pretty), do: XML.encode(bom, pretty)

  @doc """
  Decode a BOM from JSON format.

  Returns the parsed BOM struct based on the version found in the JSON.
  """
  @spec decode(String.t(), :json) :: t()
  def decode(data, format)
  def decode(data, :protobuf), do: Protobuf.decode(data)
  def decode(data, :json), do: JSON.decode(data)
  def decode(data, :xml), do: XML.decode(data)

  @doc """
  Compare two BOMs for equivalence.

  First compares directly. If not equal, canonicalizes both BOMs by removing
  volatile fields (serial_number, version, timestamp) and compares again.
  """
  @spec equivalent?(t(), t()) :: boolean()
  def equivalent?(bom1, bom2) do
    bom1 == bom2 or canonicalize_bom(bom1) == canonicalize_bom(bom2)
  end

  @doc """
  Canonicalize a BOM for comparison by removing volatile fields that change
  between generations but don't indicate actual content changes.

  Removes: serial_number, version, and timestamp from metadata.
  """
  @spec canonicalize_bom(t()) :: t()
  def canonicalize_bom(%{} = bom) do
    bom
    |> Map.put(:serial_number, nil)
    |> Map.put(:version, nil)
    |> Map.update(:metadata, nil, &canonicalize_metadata/1)
  end

  @spec canonicalize_metadata(metadata() | nil) :: metadata() | nil
  defp canonicalize_metadata(nil), do: nil

  defp canonicalize_metadata(%{} = metadata) do
    Map.put(metadata, :timestamp, nil)
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
    filtered =
      components
      |> Enum.filter(fn {_name, component} ->
        component_only = Map.get(component, :only, [:*])
        component_targets = Map.get(component, :targets, [:*])

        env_overlaps?(only, component_only) and env_overlaps?(targets, component_targets)
      end)
      |> Map.new()

    filtered_dependencies = filtered |> Map.keys() |> MapSet.new()

    Map.new(filtered, fn {name, component} ->
      filtered_deps =
        component.dependencies
        |> List.wrap()
        |> Enum.filter(&MapSet.member?(filtered_dependencies, &1.name))

      {name, Map.put(component, :dependencies, filtered_deps)}
    end)
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
    source_url_reference =
      case component[:source_url] do
        nil -> nil
        source_url -> source_url_reference(source_url, schema_version)
      end

    asset_reference = asset_reference(component, schema_version)

    hashes =
      case component[:package_url] do
        %{qualifiers: qualifiers} when qualifiers != %{} ->
          case qualifiers_to_hashes(qualifiers, schema_version) do
            [] -> nil
            hashes -> hashes
          end

        _other ->
          nil
      end

    cpe =
      name
      |> to_string()
      |> SBoM.CPE.hex(component[:version] || "", component[:source_url])

    bom_struct(:Component, schema_version,
      type: :CLASSIFICATION_LIBRARY,
      name: name,
      version: component_version(component, schema_version),
      purl: to_string(component.package_url),
      scope: dependency_scope(component),
      hashes: hashes,
      licenses: component[:licenses] |> List.wrap() |> convert_licenses(schema_version),
      bom_ref: generate_bom_ref(component.package_url),
      cpe: cpe,
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
      hashes: qualifiers_to_hashes(qualifiers, version)
    )
  end

  defp asset_reference(_component, _version), do: nil

  @spec links_references(
          links :: %{optional(String.t()) => String.t()},
          SBoM.CLI.schema_version()
        ) :: [external_reference()]
  defp links_references(links, version) do
    alias SBoM.Fetcher.Links

    links
    |> Links.normalize_link_keys()
    |> Enum.map(fn {name, url} ->
      type =
        case name do
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
      dependency_refs =
        component_data.dependencies
        |> List.wrap()
        |> Enum.map(fn dep_purl ->
          bom_struct(:Dependency, version, ref: generate_bom_ref(dep_purl))
        end)

      bom_struct(:Dependency, version,
        ref: generate_bom_ref(component_data.package_url),
        dependencies: dependency_refs
      )
    end
  end

  @spec generate_bom_ref(Purl.t()) :: String.t()
  defp generate_bom_ref(purl) do
    hash = purl |> to_string() |> :erlang.phash2()
    "urn:otp:component:#{purl.name}:#{hash}"
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

  @spec bom_struct_module(module(), SBoM.CLI.schema_version()) :: module()
  def bom_struct_module(module, version)

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

    # Safe: Module.concat is called at compile time with well-known module names from a fixed map
    # credo:disable-for-next-line Credo.Check.Warning.UnsafeToAtom
    def bom_struct_module(module, unquote(schema_version)), do: Module.concat([unquote(prefix), module])
  end

  @spec bom_struct_version(module()) :: SBoM.CLI.schema_version()
  def bom_struct_version(module) do
    ["SBoM", "Cyclonedx", "V" <> version | _rest] = Module.split(module)

    case version do
      "13" -> "1.3"
      "14" -> "1.4"
      "15" -> "1.5"
      "16" -> "1.6"
      "17" -> "1.7"
    end
  end

  @spec qualifiers_to_hashes(map(), SBoM.CLI.schema_version()) :: [struct()]
  defp qualifiers_to_hashes(%{"checksum" => "sha256:" <> hash}, version) do
    [
      bom_struct(:Hash, version,
        alg: :HASH_ALG_SHA_256,
        value: hash
      )
    ]
  end

  defp qualifiers_to_hashes(_qualifiers, _version), do: []

  @spec component_version(SBoM.Fetcher.dependency(), SBoM.CLI.schema_version()) ::
          String.t() | nil
  defp component_version(component, schema_version) do
    case schema_version do
      "1.3" -> component[:version] || component[:version_requirement] || "unknown"
      # TODO: Handle VersionRequirement separately in 1.7+
      _schema_version -> component[:version] || component[:version_requirement]
    end
  end
end
