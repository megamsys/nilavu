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


  attr_reader :assemblies_grouped

  DEW                 =  'DEW'.freeze
  APP                 =  'APP'.freeze
  SERVICE             =  'SERVICE'.freeze
  ANALYTICS           =  'ANALYTICS'.freeze
  ADDON               =  'ADDON'.freeze
  CATTYPES            =  [APP, ADDON, DEW, ANALYTICS, SERVICE]

  START               =  'start'.freeze
  STOP                =  'stop'.freeze
  RESTART             =  'restart'.freeze
  DELETE              =  'delete'.freeze
  TERMINATED          =  'Terminated'.freeze
  LAUNCHING           =  'LAUNCHING'.freeze


  def initialize()
    @assemblies_grouped = {}
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
    dig_assembly(raw[:body],api_params) unless raw == nil
    yield self  if block_given?
    return self
  end


 def create(api_params, &block)
    api_request(api_params.merge(mk(api_params)), ASSEMBLIES, CREATE)
    yield self if block_given?
    return self
  end

  private

  def mk(api_params)
    { :name=>"",
      :assemblies=> Assembly.new.build(api_params),
      :inputs=>[]
    }
  end

  #The /assemblies just returns an id of assembly. dig recursively to get the full content of it.
  #     assemblies : :id  => ASM0001
  #          assembly: :id => ASC0001
  #              component :id => CMP0001
  def dig_assembly(tmp_assemblies_collection, api_params)
    tmp_assemblies_collection.map do |one_assemblies|
         a0 = one_assemblies.assemblies.map  do  |one_assembly|
          if !one_assembly.empty?
            @assemblies_grouped = @assemblies_grouped.merge(Assembly.new.show(api_params.merge({"id" => one_assembly})).by_cattypes)
          else
            nil
          end
        end
    end
# we don't need an assemblies_collection, so leave it as is.
    Rails.logger.debug "\033[36m>-- ASB'S: START\33[0m"
    Rails.logger.debug "\033[1m#{@assemblies_grouped.to_yaml}\33[22m"
    Rails.logger.debug "\033[36m> ASB'S: END\033[0m"
  end

end
