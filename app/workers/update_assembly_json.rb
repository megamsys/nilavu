class UpdateAssemblyJson
  def self.perform(assembly, component)
    assembly.policies << {"name"=>"bind policy","ptype"=>"colocated","members"=>[assembly.name+"."+component.inputs[:domain]+"/"+component.name] }
    hash = {
      "id" => assembly.id,
      "name" => assembly.name,
      "components" => assembly.components,
      "policies" => assembly.policies,
      "inputs" => assembly.inputs,
      "operations" => assembly.operations,
      "status" => assembly.status,
      "created_at" => assembly.created_at
    }

    hash
  end

end