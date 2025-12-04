# SPDX-License-Identifier: BSD-3-Clause
# SPDX-FileCopyrightText: 2025 Erlang Ecosystem Foundation

alias SBoM.CycloneDX.XML.Encodable

require Protocol

defprotocol SBoM.CycloneDX.XML.Encodable do
  @moduledoc false

  @doc """
  Converts a CycloneDX struct to an XML element tuple suitable for :xmerl.

  Returns a tuple in the format {element_name, attributes, content}.
  """
  def to_xml_element(struct)
end

defimpl SBoM.CycloneDX.XML.Encodable, for: Any do
  def to_xml_element(_value) do
    raise "No XML Encodable implementation for #{inspect(__MODULE__)}"
  end

  defmacro __deriving__(module, _struct, options) do
    attributes = options |> Keyword.get(:attributes, []) |> Macro.escape()
    elements = options |> Keyword.get(:elements, []) |> Macro.escape()

    element_name =
      case Keyword.get(options, :element_name, nil) do
        nil ->
          # Safe: String.to_atom is called at compile time with well-known module names during macro expansion
          # credo:disable-for-next-line Credo.Check.Warning.UnsafeToAtom
          module |> Module.split() |> List.last() |> Macro.underscore() |> String.to_atom()

        name ->
          name
      end

    quote do
      defimpl SBoM.CycloneDX.XML.Encodable, for: unquote(module) do
        alias SBoM.CycloneDX.XML.Encoder

        def to_xml_element(struct) do
          attrs = Encoder.encode_fields_as_attrs(unquote(attributes), struct)
          element_content = Encoder.encode_fields_as_elements(unquote(elements), struct)

          {unquote(element_name), attrs, element_content}
        end
      end
    end
  end
end

defimpl SBoM.CycloneDX.XML.Encodable,
  for: [
    SBoM.Cyclonedx.V17.ExternalReference,
    SBoM.Cyclonedx.V16.ExternalReference,
    SBoM.Cyclonedx.V15.ExternalReference,
    SBoM.Cyclonedx.V14.ExternalReference,
    SBoM.Cyclonedx.V13.ExternalReference
  ] do
  alias SBoM.CycloneDX.Common.EnumHelpers
  alias SBoM.CycloneDX.XML.Encoder

  @impl Encodable
  def to_xml_element(external_reference) do
    external_reference =
      Map.update!(external_reference, :type, &EnumHelpers.external_reference_type_to_string/1)

    # Use helpers to build structure
    attrs = Encoder.encode_fields_as_attrs([{:type, :type}], external_reference)

    content =
      Encoder.encode_fields_as_elements(
        [
          {:url, :url, :wrap},
          {:comment, :comment, :wrap},
          {:hashes, :hashes, :wrap},
          {:properties, :properties, :unwrap}
        ],
        external_reference
      )

    {:reference, attrs, content}
  end
end

defimpl SBoM.CycloneDX.XML.Encodable,
  for: [
    SBoM.Cyclonedx.V17.Hash,
    SBoM.Cyclonedx.V16.Hash,
    SBoM.Cyclonedx.V15.Hash,
    SBoM.Cyclonedx.V14.Hash,
    SBoM.Cyclonedx.V13.Hash
  ] do
  alias SBoM.CycloneDX.Common.EnumHelpers

  @impl Encodable
  def to_xml_element(hash) do
    alg_string = EnumHelpers.hash_alg_to_string(hash.alg)
    {:hash, [{:alg, alg_string}], [[hash.value]]}
  end
end

defimpl SBoM.CycloneDX.XML.Encodable,
  for: [
    SBoM.Cyclonedx.V17.Component,
    SBoM.Cyclonedx.V16.Component,
    SBoM.Cyclonedx.V15.Component,
    SBoM.Cyclonedx.V14.Component,
    SBoM.Cyclonedx.V13.Component
  ] do
  alias SBoM.CycloneDX.Common.EnumHelpers
  alias SBoM.CycloneDX.XML.Encoder

  @impl Encodable
  def to_xml_element(component) do
    component =
      component
      |> Map.update!(:type, &EnumHelpers.classification_to_string_xml/1)
      |> Map.update(:scope, nil, &EnumHelpers.scope_to_string/1)

    # Use helpers to build structure
    attrs = Encoder.encode_fields_as_attrs([{:type, :type}, {:"bom-ref", :bom_ref}], component)

    content =
      Encoder.encode_fields_as_elements(
        [
          {:supplier, :supplier, :unwrap},
          {:manufacturer, :manufacturer, :unwrap},
          {:authors, :authors, :unwrap},
          {:author, :author, :wrap},
          {:publisher, :publisher, :wrap},
          {:group, :group, :wrap},
          {:name, :name, :wrap},
          {:version, :version, :wrap},
          {:versionRange, :version_range, :wrap},
          {:description, :description, :wrap},
          {:scope, :scope, :wrap},
          {:hashes, :hashes, :unwrap},
          {:licenses, :licenses, :unwrap},
          {:copyright, :copyright, :wrap},
          {:patentAssertions, :patent_assertions, :unwrap},
          {:cpe, :cpe, :wrap},
          {:purl, :purl, :wrap},
          {:externalReferences, :external_references, :wrap},
          {:properties, :properties, :unwrap},
          {:evidence, :evidence, :unwrap},
          {:releaseNotes, :release_notes, :unwrap},
          {:modelCard, :model_card, :unwrap},
          {:data, :data, :unwrap},
          {:cryptoProperties, :crypto_properties, :unwrap},
          {:components, :components, :unwrap}
        ],
        component
      )

    {:component, attrs, content}
  end
end

defimpl SBoM.CycloneDX.XML.Encodable, for: BitString do
  @impl Encodable
  def to_xml_element(value) do
    [[value]]
  end
end

defimpl SBoM.CycloneDX.XML.Encodable, for: List do
  @impl Encodable
  def to_xml_element(list) do
    Enum.map(list, &Encodable.to_xml_element/1)
  end
end

defimpl SBoM.CycloneDX.XML.Encodable, for: Google.Protobuf.Timestamp do
  @impl Encodable
  def to_xml_element(timestamp) do
    datetime = Google.Protobuf.to_datetime(timestamp)
    iso_string = DateTime.to_iso8601(datetime)
    [List.wrap(iso_string)]
  end
end

Protocol.derive(Encodable, SBoM.Cyclonedx.V17.Bom,
  element_name: :bom,
  attributes: [
    {:version, :version},
    {:serialNumber, :serial_number},
    {:"xmlns:xsi", {:static, "http://www.w3.org/2001/XMLSchema-instance"}},
    {:"xmlns:xsd", {:static, "http://www.w3.org/2001/XMLSchema"}},
    {:xmlns, {:static, "http://cyclonedx.org/schema/bom/1.7"}}
  ],
  elements: [
    {:metadata, :metadata, :unwrap},
    {:components, :components, :wrap},
    {:services, :services, :wrap},
    {:"external-references", :external_references, :wrap},
    {:dependencies, :dependencies, :wrap},
    {:compositions, :compositions, :wrap},
    {:vulnerabilities, :vulnerabilities, :wrap},
    {:annotations, :annotations, :wrap},
    {:properties, :properties, :wrap},
    {:formulation, :formulation, :wrap},
    {:declarations, :declarations, :wrap},
    {:definitions, :definitions, :wrap},
    {:citations, :citations, :wrap}
  ]
)

Protocol.derive(Encodable, SBoM.Cyclonedx.V16.Bom,
  element_name: :bom,
  attributes: [
    {:version, :version},
    {:serialNumber, :serial_number},
    {:"xmlns:xsi", {:static, "http://www.w3.org/2001/XMLSchema-instance"}},
    {:"xmlns:xsd", {:static, "http://www.w3.org/2001/XMLSchema"}},
    {:xmlns, {:static, "http://cyclonedx.org/schema/bom/1.6"}}
  ],
  elements: [
    {:metadata, :metadata, :unwrap},
    {:components, :components, :wrap},
    {:services, :services, :wrap},
    {:"external-references", :external_references, :wrap},
    {:dependencies, :dependencies, :wrap},
    {:compositions, :compositions, :wrap},
    {:vulnerabilities, :vulnerabilities, :wrap},
    {:annotations, :annotations, :wrap},
    {:properties, :properties, :wrap},
    {:formulation, :formulation, :wrap},
    {:declarations, :declarations, :wrap},
    {:definitions, :definitions, :wrap}
  ]
)

Protocol.derive(Encodable, SBoM.Cyclonedx.V15.Bom,
  element_name: :bom,
  attributes: [
    {:version, :version},
    {:serialNumber, :serial_number},
    {:"xmlns:xsi", {:static, "http://www.w3.org/2001/XMLSchema-instance"}},
    {:"xmlns:xsd", {:static, "http://www.w3.org/2001/XMLSchema"}},
    {:xmlns, {:static, "http://cyclonedx.org/schema/bom/1.5"}}
  ],
  elements: [
    {:metadata, :metadata, :unwrap},
    {:components, :components, :wrap},
    {:services, :services, :wrap},
    {:"external-references", :external_references, :wrap},
    {:dependencies, :dependencies, :wrap},
    {:compositions, :compositions, :wrap},
    {:vulnerabilities, :vulnerabilities, :wrap},
    {:annotations, :annotations, :wrap},
    {:properties, :properties, :wrap},
    {:formulation, :formulation, :wrap}
  ]
)

Protocol.derive(Encodable, SBoM.Cyclonedx.V14.Bom,
  element_name: :bom,
  attributes: [
    {:version, :version},
    {:serialNumber, :serial_number},
    {:"xmlns:xsi", {:static, "http://www.w3.org/2001/XMLSchema-instance"}},
    {:"xmlns:xsd", {:static, "http://www.w3.org/2001/XMLSchema"}},
    {:xmlns, {:static, "http://cyclonedx.org/schema/bom/1.4"}}
  ],
  elements: [
    {:metadata, :metadata, :unwrap},
    {:components, :components, :wrap},
    {:services, :services, :wrap},
    {:"external-references", :external_references, :wrap},
    {:dependencies, :dependencies, :wrap},
    {:compositions, :compositions, :wrap},
    {:vulnerabilities, :vulnerabilities, :wrap}
  ]
)

Protocol.derive(Encodable, SBoM.Cyclonedx.V13.Bom,
  element_name: :bom,
  attributes: [
    {:version, :version},
    {:serialNumber, :serial_number},
    {:"xmlns:xsi", {:static, "http://www.w3.org/2001/XMLSchema-instance"}},
    {:"xmlns:xsd", {:static, "http://www.w3.org/2001/XMLSchema"}},
    {:xmlns, {:static, "http://cyclonedx.org/schema/bom/1.3"}}
  ],
  elements: [
    {:metadata, :metadata, :unwrap},
    {:components, :components, :wrap},
    {:services, :services, :wrap},
    {:"external-references", :external_references, :wrap},
    {:dependencies, :dependencies, :wrap},
    {:compositions, :compositions, :wrap}
  ]
)

Protocol.derive(Encodable, SBoM.Cyclonedx.V17.Metadata,
  elements: [
    {:timestamp, :timestamp, :wrap},
    {:lifecycles, :lifecycles, :wrap},
    {:tools, :tools, :unwrap},
    {:authors, :authors, :wrap},
    {:component, :component, :unwrap},
    {:manufacturer, :manufacturer, :unwrap},
    {:manufacture, :manufacture, :unwrap},
    {:supplier, :supplier, :unwrap},
    {:licenses, :licenses, :wrap},
    {:properties, :properties, :wrap},
    {:distributionConstraints, :distribution_constraints, :unwrap}
  ]
)

Protocol.derive(Encodable, SBoM.Cyclonedx.V16.Metadata,
  elements: [
    {:timestamp, :timestamp, :wrap},
    {:lifecycles, :lifecycles, :wrap},
    {:tools, :tools, :unwrap},
    {:authors, :authors, :wrap},
    {:component, :component, :unwrap},
    {:manufacturer, :manufacturer, :unwrap},
    {:manufacture, :manufacture, :unwrap},
    {:supplier, :supplier, :unwrap},
    {:licenses, :licenses, :wrap},
    {:properties, :properties, :wrap}
  ]
)

Protocol.derive(Encodable, SBoM.Cyclonedx.V15.Metadata,
  elements: [
    {:timestamp, :timestamp, :wrap},
    {:lifecycles, :lifecycles, :wrap},
    {:tools, :tools, :unwrap},
    {:authors, :authors, :wrap},
    {:component, :component, :unwrap},
    {:manufacture, :manufacture, :unwrap},
    {:supplier, :supplier, :unwrap},
    {:licenses, :licenses, :wrap},
    {:properties, :properties, :wrap}
  ]
)

Protocol.derive(Encodable, SBoM.Cyclonedx.V14.Metadata,
  elements: [
    {:timestamp, :timestamp, :wrap},
    {:tools, :tools, :wrap},
    {:authors, :authors, :wrap},
    {:component, :component, :unwrap},
    {:manufacture, :manufacture, :unwrap},
    {:supplier, :supplier, :unwrap},
    {:licenses, :licenses, :wrap},
    {:properties, :properties, :wrap}
  ]
)

Protocol.derive(Encodable, SBoM.Cyclonedx.V13.Metadata,
  elements: [
    {:timestamp, :timestamp, :wrap},
    {:tools, :tools, :wrap},
    {:authors, :authors, :wrap},
    {:component, :component, :unwrap},
    {:manufacture, :manufacture, :unwrap},
    {:supplier, :supplier, :unwrap},
    {:licenses, :licenses, :wrap},
    {:properties, :properties, :wrap}
  ]
)

Protocol.derive(Encodable, SBoM.Cyclonedx.V17.Tool,
  element_name: :tool,
  elements: [
    {:vendor, :vendor, :wrap},
    {:name, :name, :wrap},
    {:version, :version, :wrap},
    {:components, :components, :wrap},
    {:services, :services, :wrap}
  ]
)

Protocol.derive(Encodable, SBoM.Cyclonedx.V16.Tool,
  element_name: :tool,
  elements: [
    {:vendor, :vendor, :wrap},
    {:name, :name, :wrap},
    {:version, :version, :wrap},
    {:components, :components, :wrap},
    {:services, :services, :wrap}
  ]
)

Protocol.derive(Encodable, SBoM.Cyclonedx.V15.Tool,
  element_name: :tool,
  elements: [
    {:vendor, :vendor, :wrap},
    {:name, :name, :wrap},
    {:version, :version, :wrap},
    {:components, :components, :wrap},
    {:services, :services, :wrap}
  ]
)

Protocol.derive(Encodable, SBoM.Cyclonedx.V14.Tool,
  element_name: :tool,
  elements: [
    {:vendor, :vendor, :wrap},
    {:name, :name, :wrap},
    {:version, :version, :wrap},
    {:hashes, :hashes, :wrap},
    {:"external-references", :external_references, :wrap}
  ]
)

Protocol.derive(Encodable, SBoM.Cyclonedx.V13.Tool,
  element_name: :tool,
  elements: [
    {:vendor, :vendor, :wrap},
    {:name, :name, :wrap},
    {:version, :version, :wrap},
    {:hashes, :hashes, :wrap}
  ]
)

Protocol.derive(Encodable, SBoM.Cyclonedx.V17.OrganizationalEntity,
  elements: [
    {:name, :name, :wrap},
    {:url, :url, :wrap},
    {:contact, :contact, :wrap}
  ]
)

Protocol.derive(Encodable, SBoM.Cyclonedx.V16.OrganizationalEntity,
  elements: [
    {:name, :name, :wrap},
    {:url, :url, :wrap},
    {:contact, :contact, :wrap}
  ]
)

Protocol.derive(Encodable, SBoM.Cyclonedx.V15.OrganizationalEntity,
  elements: [
    {:name, :name, :wrap},
    {:url, :url, :wrap},
    {:contact, :contact, :wrap}
  ]
)

Protocol.derive(Encodable, SBoM.Cyclonedx.V14.OrganizationalEntity,
  elements: [
    {:name, :name, :wrap},
    {:url, :url, :wrap},
    {:contact, :contact, :wrap}
  ]
)

Protocol.derive(Encodable, SBoM.Cyclonedx.V13.OrganizationalEntity,
  elements: [
    {:name, :name, :wrap},
    {:url, :url, :wrap},
    {:contact, :contact, :wrap}
  ]
)

Protocol.derive(Encodable, SBoM.Cyclonedx.V17.LicenseChoice,
  element_name: :license,
  attributes: [
    {:"bom-ref", :bom_ref}
  ],
  elements: [
    {:license, {:choice, :license}, :unwrap},
    {:expression, {:choice, :expression}, :wrap}
  ]
)

Protocol.derive(Encodable, SBoM.Cyclonedx.V16.LicenseChoice,
  element_name: :licenses,
  attributes: [
    {:"bom-ref", :bom_ref}
  ],
  elements: [
    {:license, {:choice, :license}, :unwrap},
    {:expression, {:choice, :expression}, :wrap}
  ]
)

Protocol.derive(Encodable, SBoM.Cyclonedx.V15.LicenseChoice,
  element_name: :licenses,
  attributes: [
    {:"bom-ref", :bom_ref}
  ],
  elements: [
    {:license, {:choice, :license}, :unwrap},
    {:expression, {:choice, :expression}, :wrap}
  ]
)

Protocol.derive(Encodable, SBoM.Cyclonedx.V14.LicenseChoice,
  element_name: :licenses,
  attributes: [
    {:"bom-ref", :bom_ref}
  ],
  elements: [
    {:license, {:choice, :license}, :unwrap},
    {:expression, {:choice, :expression}, :wrap}
  ]
)

Protocol.derive(Encodable, SBoM.Cyclonedx.V13.LicenseChoice,
  element_name: :licenses,
  attributes: [
    {:"bom-ref", :bom_ref}
  ],
  elements: [
    {:license, {:choice, :license}, :unwrap},
    {:expression, {:choice, :expression}, :wrap}
  ]
)

Protocol.derive(Encodable, SBoM.Cyclonedx.V17.License,
  element_name: :license,
  attributes: [
    {:"bom-ref", :bom_ref}
  ],
  elements: [
    {:id, {:license, :id}, :wrap},
    {:name, {:license, :name}, :wrap},
    {:text, :text, :unwrap},
    {:url, :url, :wrap},
    {:licensing, :licensing, :unwrap},
    {:properties, :properties, :unwrap}
  ]
)

Protocol.derive(Encodable, SBoM.Cyclonedx.V16.License,
  element_name: :license,
  attributes: [
    {:"bom-ref", :bom_ref}
  ],
  elements: [
    {:id, {:license, :id}, :wrap},
    {:name, {:license, :name}, :wrap},
    {:text, :text, :unwrap},
    {:url, :url, :wrap},
    {:licensing, :licensing, :unwrap},
    {:properties, :properties, :unwrap}
  ]
)

Protocol.derive(Encodable, SBoM.Cyclonedx.V15.License,
  element_name: :license,
  attributes: [
    {:"bom-ref", :bom_ref}
  ],
  elements: [
    {:id, {:license, :id}, :wrap},
    {:name, {:license, :name}, :wrap},
    {:text, :text, :unwrap},
    {:url, :url, :wrap},
    {:licensing, :licensing, :unwrap},
    {:properties, :properties, :unwrap}
  ]
)

Protocol.derive(Encodable, SBoM.Cyclonedx.V14.License,
  element_name: :license,
  attributes: [
    {:"bom-ref", :bom_ref}
  ],
  elements: [
    {:id, {:license, :id}, :wrap},
    {:name, {:license, :name}, :wrap},
    {:text, :text, :unwrap},
    {:url, :url, :wrap}
  ]
)

Protocol.derive(Encodable, SBoM.Cyclonedx.V13.License,
  element_name: :license,
  attributes: [
    {:"bom-ref", :bom_ref}
  ],
  elements: [
    {:id, {:license, :id}, :wrap},
    {:name, {:license, :name}, :wrap},
    {:text, :text, :unwrap},
    {:url, :url, :wrap}
  ]
)

Protocol.derive(Encodable, SBoM.Cyclonedx.V17.Dependency,
  element_name: :dependency,
  attributes: [
    {:ref, :ref}
  ],
  elements: [
    {:dependency, :dependencies, :keep}
  ]
)

Protocol.derive(Encodable, SBoM.Cyclonedx.V16.Dependency,
  element_name: :dependency,
  attributes: [
    {:ref, :ref}
  ],
  elements: [
    {:dependency, :dependencies, :keep}
  ]
)

Protocol.derive(Encodable, SBoM.Cyclonedx.V15.Dependency,
  element_name: :dependency,
  attributes: [
    {:ref, :ref}
  ],
  elements: [
    {:dependency, :dependencies, :keep}
  ]
)

Protocol.derive(Encodable, SBoM.Cyclonedx.V14.Dependency,
  element_name: :dependency,
  attributes: [
    {:ref, :ref}
  ],
  elements: [
    {:dependency, :dependencies, :keep}
  ]
)

Protocol.derive(Encodable, SBoM.Cyclonedx.V13.Dependency,
  element_name: :dependency,
  attributes: [
    {:ref, :ref}
  ],
  elements: [
    {:dependency, :dependencies, :keep}
  ]
)

Protocol.derive(Encodable, SBoM.Cyclonedx.V17.OrganizationalContact,
  element_name: :author,
  attributes: [
    {:bom_ref, :"bom-ref"}
  ],
  elements: [
    {:name, :name, :wrap},
    {:email, :email, :wrap},
    {:phone, :phone, :wrap}
  ]
)

Protocol.derive(Encodable, SBoM.Cyclonedx.V16.OrganizationalContact,
  element_name: :author,
  attributes: [
    {:bom_ref, :"bom-ref"}
  ],
  elements: [
    {:name, :name, :wrap},
    {:email, :email, :wrap},
    {:phone, :phone, :wrap}
  ]
)
