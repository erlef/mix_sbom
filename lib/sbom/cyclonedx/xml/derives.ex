alias SBoM.CycloneDX.XML.Encodable

require Protocol

defimpl SBoM.CycloneDX.XML.Encodable, for: BitString do
  def to_xml_element(value) do
    [[value]]
  end
end

defimpl SBoM.CycloneDX.XML.Encodable, for: List do
  def to_xml_element(list) do
    Enum.map(list, &Encodable.to_xml_element/1)
  end
end

defimpl SBoM.CycloneDX.XML.Encodable, for: Google.Protobuf.Timestamp do
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
    {:component, :component, :unwrap},
    {:manufacture, :manufacture, :unwrap},
    {:supplier, :supplier, :unwrap},
    {:manufacturer, :manufacturer, :unwrap},
    {:tools, :tools, :unwrap},
    {:authors, :authors, :wrap},
    {:licenses, :licenses, :wrap},
    {:properties, :properties, :wrap},
    {:lifecycles, :lifecycles, :wrap}
  ]
)

Protocol.derive(Encodable, SBoM.Cyclonedx.V16.Metadata,
  elements: [
    {:timestamp, :timestamp, :wrap},
    {:component, :component, :unwrap},
    {:manufacture, :manufacture, :unwrap},
    {:supplier, :supplier, :unwrap},
    {:manufacturer, :manufacturer, :unwrap},
    {:tools, :tools, :unwrap},
    {:authors, :authors, :wrap},
    {:licenses, :licenses, :wrap},
    {:properties, :properties, :wrap},
    {:lifecycles, :lifecycles, :wrap}
  ]
)

Protocol.derive(Encodable, SBoM.Cyclonedx.V15.Metadata,
  elements: [
    {:timestamp, :timestamp, :wrap},
    {:component, :component, :unwrap},
    {:manufacture, :manufacture, :unwrap},
    {:supplier, :supplier, :unwrap},
    {:tools, :tools, :unwrap},
    {:authors, :authors, :wrap},
    {:licenses, :licenses, :wrap},
    {:properties, :properties, :wrap},
    {:lifecycles, :lifecycles, :wrap}
  ]
)

Protocol.derive(Encodable, SBoM.Cyclonedx.V14.Metadata,
  elements: [
    {:timestamp, :timestamp, :wrap},
    {:component, :component, :unwrap},
    {:manufacture, :manufacture, :unwrap},
    {:supplier, :supplier, :unwrap},
    {:tools, :tools, :wrap},
    {:authors, :authors, :wrap},
    {:licenses, :licenses, :wrap},
    {:properties, :properties, :wrap}
  ]
)

Protocol.derive(Encodable, SBoM.Cyclonedx.V13.Metadata,
  elements: [
    {:timestamp, :timestamp, :wrap},
    {:component, :component, :unwrap},
    {:manufacture, :manufacture, :unwrap},
    {:supplier, :supplier, :unwrap},
    {:tools, :tools, :wrap},
    {:authors, :authors, :wrap},
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
  element_name: :licenses,
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

# Dependency derives
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
