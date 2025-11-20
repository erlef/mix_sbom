defmodule SBoM.CycloneDX do
  @moduledoc false

  alias SBoM.CycloneDX.JSON.Encodable
  alias SBoM.CycloneDX.XML.Encodable, as: XMLEncodable

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
  @type uuid() :: <<_::288>>

  @version Mix.Project.config()[:version]

  @spec empty(SBoM.CLI.schema_version()) :: t()
  def empty(version \\ "1.7") do
    bom_struct(:Bom, version,
      spec_version: version,
      serial_number: urn_uuid(),
      version: 1,
      metadata: bom_struct(:Metadata, version)
    )
  end

  @spec bom(components_map(), t()) :: t()
  def bom(components, bom \\ empty()) do
    %{spec_version: version} = bom

    bom_components = attach_components(components, version)

    bom
    |> Map.put(:serial_number, urn_uuid())
    |> Map.update!(:version, &(&1 + 1))
    |> Map.update!(:metadata, &attach_metadata(&1, version))
    |> Map.put(:components, bom_components)
    |> Map.put(:dependencies, attach_dependencies(components, version))
  end

  @spec encode(t(), SBoM.CLI.format()) :: iodata()
  def encode(bom, type)
  def encode(%module{} = bom, :protobuf), do: module.encode(bom)

  def encode(bom, :json) do
    bom
    |> Encodable.to_encodable()
    |> JSON.encode!()
  end

  def encode(bom, :xml) do
    utf8_bom = <<0xEF, 0xBB, 0xBF>>

    xml_content =
      bom
      |> XMLEncodable.to_xml_element()
      |> List.wrap()
      |> :xmerl.export_simple(:xmerl_xml, [
        {:prolog, ~c"<?xml version=\"1.0\" encoding=\"utf-8\"?>"}
      ])
      |> IO.iodata_to_binary()

    utf8_bom <> xml_content
  end

  @spec attach_metadata(metadata(), SBoM.CLI.schema_version()) :: metadata()
  defp attach_metadata(metadata, version)

  defp attach_metadata(metadata, version) when version in ["1.3", "1.4"] do
    metadata
    |> Map.put(:timestamp, Google.Protobuf.from_datetime(DateTime.utc_now()))
    |> Map.update!(:tools, fn tools ->
      tools
      |> List.wrap()
      |> Enum.reject(&match?(%{name: "Mix SBoM", vendor: "Erlang Ecosystem Foundation"}, &1))
      |> then(&[tool(version) | &1])
    end)
  end

  defp attach_metadata(metadata, version) do
    metadata
    |> Map.put(:timestamp, Google.Protobuf.from_datetime(DateTime.utc_now()))
    |> Map.update!(:tools, fn tools ->
      tools = tools || bom_struct(:Tool, version)

      components =
        tools.components
        |> List.wrap()
        |> Enum.reject(&match?(%{name: "Mix SBoM", supplier: %{name: "Erlang Ecosystem Foundation"}}, &1))
        |> then(&[tool(version) | &1])

      %{tools | components: components}
    end)
  end

  @spec attach_components(components_map(), SBoM.CLI.schema_version()) :: [component()]
  defp attach_components(components, version) do
    Enum.map(components, fn {name, component_data} ->
      convert_component(name, component_data, version)
    end)
  end

  @spec convert_component(
          SBoM.Fetcher.app_name(),
          SBoM.Fetcher.dependency(),
          SBoM.CLI.schema_version()
        ) :: struct()
  defp convert_component(name, component, version) do
    purl_string = to_string(component.package_url)

    bom_struct(:Component, version,
      type: :CLASSIFICATION_LIBRARY,
      name: name,
      version: component.package_url.version,
      purl: purl_string,
      scope: map_scope(component.scope),
      licenses: convert_licenses(component.metadata["license"], version),
      bom_ref: generate_bom_ref(purl_string)
    )
  end

  # TODO: Refactor to a format that uses seperate fields (runtime, optional, target etc to get the scope)
  @spec map_scope(atom()) :: scope()
  defp map_scope(:runtime), do: :SCOPE_REQUIRED
  defp map_scope(:optional), do: :SCOPE_OPTIONAL
  defp map_scope(_other_scope), do: :SCOPE_REQUIRED

  @spec convert_licenses(String.t() | nil | term(), SBoM.CLI.schema_version()) :: license_list()
  defp convert_licenses(nil, _version), do: []

  defp convert_licenses(license, version) when is_binary(license) do
    [
      bom_struct(:LicenseChoice, version, choice: {:license, bom_struct(:License, version, license: {:id, license})})
    ]
  end

  defp convert_licenses(_other_license, _version), do: []

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
end
