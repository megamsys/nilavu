class UpdateComponentJson
  def self.perform(component, relatedcomponent)
    hash = {
      "id" => component.id,
      "name" => component.name,
      "tosca_type" => component.tosca_type,
      "requirements" => {
        "host" => component.requirements[:host],
        "dummy" => component.requirements[:dummy]
      },
      "inputs" => component.inputs,
      "external_management_resource" => component.external_management_resource,
      "artifacts" => component.artifacts,
      "related_components" => relatedcomponent,
      "operations" => component.operations,
      "created_at" => component.created_at
    }

    hash
  end

end