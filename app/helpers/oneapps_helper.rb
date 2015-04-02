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

def mkp_config
    YAML.load(File.open("#{Rails.root}/config/marketplace_addons.yml", 'r'))
  end

  def change_runtime(deps, runtime)
    project_name = File.basename(deps).split(".").first
    if /<projectname>/.match(runtime)
      runtime["unicorn_<projectname>"] = "unicorn_" + project_name
    end
    runtime
  end
  
  def get_type(name)
   @type = ""  
    mkp_config.each do |mkp, addon|
      if mkp == name
        @type = addon["type"]
      end
    end  
    @type
 end
  
end
