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
  
  START               =  'start'.freeze
  STOP                =  'stop'.freeze
  RESTART             =  'restart'.freeze
  DELETE              =  'delete'.freeze
  TERMINATED          =  'Terminated'.freeze

  def initialize()
    @assemblies_collection = []
    @assemblies_grouped = []     
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
    @assemblies_collection = dig_assembly(raw[:body]) unless raw == nil

    #only if the mkp is successful, we can figure out toscatype to cattype [APP, SERVICE, ADDON]
    Marketplaces.instance.list(api_params) do |mkp|
      prune.map do  |pruned_assembly_collection|
        #stick the toscatype to cattype [APP, SERVICE, ADDON]
      end unless @assemblies_collection.nil?
    end

    @assemblies_grouped = @assemblies_collection.group_by{|abck| abck} unless @assemblies_collection.nil?

    yield self  if block_given?
    return self
  end


 def create(api_params, &block)   
    api_request(make_assemblies(api_params), ASSEMBLIES, CREATE)
    yield self if block_given?
    return self
  end
  
  private
  
  def make_assemblies(params)     
    hash = {
      "name"=>"",
      "assemblies"=> Assembly.new.build(params),
      "inputs"=>[],
      :email => params["email"],
      :api_key => params["api_key"]
    }
    hash
  end   

    #wade out the nils in the assemblies_collection.
    #the error objects shouldn't be in here, but we swallow an exception for an assemblies.list.
    #hence we prune errors as well.
    def prune
      @assemblies_collection.take_while do |one_assemblies|
        one_assemblies.assemblies.take_while do |one_assembly|
          one_assembly.prune
        end unless (one_assemblies.nil? || one_assembly.is_a?(Megam::Error))
      end unless @assemblies_collectionassemblies.nil?
      @assemblies_collection
    end

    def dig_assembly(tmp_assemblies_collection)
      tmp_assemblies_collection.map do |one_assemblies|

puts " ONE ASSEMBLies ======================> "
puts one_assemblies.class
puts one_assemblies.inspect

          one_assemblies.assemblies.map  do  |one_assembly|
puts " ONE ASSEMBLY ======================> "
puts one_assembly.class
puts one_assembly.inspect
            if !one_assembly.empty?
		assembly = Assembly.new
              assembly.show(one_assembly).assembly_collection
            else
              nil
            end
          end
      end
    end

end
