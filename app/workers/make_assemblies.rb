class MakeAssemblies
  def self.perform(options, tmp_email, tmp_api_key)
    hash = {
      "name"=>"",
      "assemblies"=>[
        {
          "name"=>"#{options[:assembly_name]}",
          "components"=>[
            {
              "name"=>"#{options[:assembly_name]}",
              "tosca_type"=>"tosca.web.#{options[:type]}",
              "requirements"=> {
                "host"=>"#{options[:cloud]}",
                "dummy"=>""
              },
              "inputs"=>{
                "domain"=>"#{options[:domain]}",
                "port"=>"",
                "username"=>"",
                "password"=>"",
                "version"=>"#{options[:version]}",
                "source"=>"#{options[:source]}",
                "design_inputs"=>{
                  "id"=>"",
                  "x"=>nil,
                  "y"=>nil,
                  "z"=>nil,
                  "wires"=>[]
                },
                "service_inputs"=>{
                  "dbname"=>"",
                  "dbpassword"=>"",
                },
              },
              "external_management_resource"=>"",
              "artifacts"=>{
                "artifact_type"=>"",
                "content"=>"",
                "artifact_requirements"=>"",
              },
              "related_components"=>"",
              "operations"=>{
                "operation_type"=>"",
                "target_resource"=>"",
              },
            }
          ],
          "policies"=>[],
          "inputs"=>"",
          "operations"=>"",
        }
      ],
      "inputs"=>{
        "id"=>"",
        "assemblies_type"=>"",
        "label"=>"",
        "cloudsettings"=>[]
      }
    }

    hash
  end

end