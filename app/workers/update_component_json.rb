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