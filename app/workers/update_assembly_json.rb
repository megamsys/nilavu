##
## Copyright [2013-2015] [Megam Systems]
##
## Licensed under the Apache License, Version 2.0 (the "License");
## you may not use this file except in compliance with the License.
## You may obtain a copy of the License at
##
## http://www.apache.org/licenses/LICENSE-2.0
##
## Unless required by applicable law or agreed to in writing, software
## distributed under the License is distributed on an "AS IS" BASIS,
## WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
## See the License for the specific language governing permissions and
## limitations under the License.
##
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