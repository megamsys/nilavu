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
module CatalogHelper


   #a tosca_type exists in both assembly and in all components
   #in case of a dew, there is no component hence we pull the last word from assembly.tosca_type
   #pull the last word from tosca.dew.debian
  def sparkle_up(cattype, assembly)
    beautify_cockpit = []
    case cattype.upcase
      when Assemblies::DEW
        beautify_cockpit << ("logos/" + assembly.tosca_type.split('.').last.delete('.­!?,') + ".png")
      else
        assembly.components.each do |one_component|
          one_component.each do |c|
            beautify_cockpit << ("logos/"+ one_component.tosca_type.­split('.').last­.delete('.­!?,') + ".png")
          end
        end
      end
    beautify_cockpit
  end

end
