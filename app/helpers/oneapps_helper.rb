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
module OneappsHelper
  def change_runtime(deps, runtime)
    project_name = File.basename(deps).split('.').first
    if /<projectname>/.match(runtime)
      runtime['unicorn_<projectname>'] = 'unicorn_' + project_name
    end
    runtime
  end

  #get all the components by cattype.
  def by_cattype(components, cattype)
    tmp_comp = components.map do |k|
      k.map do |v|
        v if (/((\w+).#{cattype.downcase}.(\w+))/).match(v.tosca_type)
      end unless k.nil?
    end.flatten.compact
    tmp_comp
  end
  
  def unbound_apps(apps)
    unbound_apps  = []
    unbound_apps << "Unbound service"
    apps.map{ |c| unbound_apps << [c[:name], c[:name]+":"+c[:aid]+":"+c[:cid]] }
    unbound_apps
  end
  
  def bound_assemblies(assemblies, related_components)
    bound_assemblies = []
    related_components.map do |rc|      
      assemblies[0].map do |s|       
         if rc.split(".")[0] == s[0].name
              bound_assemblies << s[0]
          end
       end
   end    
   bound_assemblies
 end
   
end
