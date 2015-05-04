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
require 'bcrypt'
require 'json'

class Assemblies < BaseFascade
  include MarketplaceHelper


  attr_reader :services_spun
  attr_reader :dews_spun
  attr_reader :apps_spun
  attr_reader :assemblies
  attr_reader :services
  attr_reader :apps

  DEW                 =  'DEW'.freeze
  APP                 =  'APP'.freeze
  SERVICE             =  'SERVICE'.freeze


  def initialize()
    @apps_spun     = 0
    @services_spun = 0
    @dews_spun      = 0
    @assemblies= nil
    @services
    @apps
    super(true) #swallow 404 errors for assemblies.
  end

  # The list returns a list of assemblies, apps, services.
  # we also need the spun vms, apps, services
  # here is the  tree for us.
  # You can have as many assembly inside assemblies.
  # for the sake of a simple verbosology, we call plural assemblys as assembly_collection.
  # There exists a need to cyclically dug inside as we only retrieve the ids of our assemblies structure.
  # The following has 1 assembly and 2 components.
  #  -- assemblies :
  #      --assembly
  #           ---components
  #                   -- component1 : app
  #                   -- component2 : service
  # currently if there are no components then we consider it a plain VM.
  # an additional field in assembly indicates if its a plain VM (INSTANCE) or not.

  def list(api_params, &block)
    raw = api_request(api_params, ASSEMBLIES, LIST)
    @assemblies = dig_assembly(raw[:body]) unless raw == nil
    tmp = []
    tmp = @assemblies.each do |asm|
          asm.assemblies.each do |assembly|
            if assembly != nil
              if assembly[0].class != Megam::Error
                @dews_spun = @dews_spun + 1 if (assembly[0].components.length == 0)
                assembly[0].components.each do |com|
                  if com != nil
                    com.each do |c|
                      com_type = c.tosca_type.split(".")
                      ctype = get_type(com_type[2])
                      case ctype
                      when SERVICE
                        @service << {"name" => assembly[0].name + "." + c.inputs[:domain] + "/" + c.name, "aid" => assembly[0].id, "cid" => c.id }
                        @service_spun = @service_spun + 1
                      when APP
                        @app_spun = @app_spun + 1
                      when APP && com[0].related_components == ""
                        @apps << {"name" => assembly[0].name + "." + assembly[0].components[0][0].inputs[:domain] + "/" + com[0].name, "aid" => assembly[0].id, "cid" => assembly[0].components[0][0].id }
                      end
                   end
                end
              end
            end
          end
        end    if asm.class != Megam::Error
      end if raw != nil

    @assemblies  = tmp
    yield self  if block_given?
    return self
  end



  private
    def dig_assembly(tmp_assemblies_collection)
      tmp_assemblies_collection.map do |asmblies|
          asmblies.assemblies.map  do  |one_asmblies|
            if !one_asmblies.empty?
              Assembly.show(one_asmblies).assembly_collection
            else
              nil
            end
          end
      end
    end

end
