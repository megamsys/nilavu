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

class Assembly < BaseFascade

  attr_reader :assembly_collection
  
   STATUS    =  'LAUNCHING'.freeze

  def initialize()
    @assembly_collection= nil
    @DEFAULTTOSCATYPE    =  'ubuntu'  
    @inputs = []
    @requirements = []
  end

  def show(api_params, &block)
     puts "Assembly show api_params =============> "
	puts api_params.class
	puts api_params.inspect
    raw = api_request(api_params, ASSEMBLY, SHOW)
    @assembly_collection = dig_components(raw[:body])
    yield @assembly_collection  if block_given?
    return @assembly_collection
  end

 def build(params)
  mkp = JSON.parse(params["mkp"])  
  
  set_inputs(params)
  set_requirements(params) 
  
  @DEFAULTTOSCATYPE = "#{mkp["predef"]}" unless mkp["cattype"] != Assemblies::DEW
  
  components = []  
  components = Components.new.build(params) unless mkp["cattype"] == Assemblies::DEW
  
  hash = [{         
          "name"=>"#{params[:name]}",
          "tosca_type"=>"tosca.#{mkp["cattype"].downcase}.#{@DEFAULTTOSCATYPE}",
          "components"=> components,
          "requirements"=> @requirements,
          "policies"=>build_policies(params),
          "inputs"=> @inputs,
          "outputs"=>[],
          "operations"=>[],
          "status"=>STATUS,
        }]
  hash
 end
 
 #In future lot of inputs add this method
 def set_inputs(params)
   @inputs << {"key" => "sshkey", "value" => params[:ssh_key_name]} if params[:ssh_key_name] 
 end
 
 #In future lot of requirements add this method
 def set_requirements(params)
   @requirements << {"key" => "host", "value" => params[:host]} if params.has_key?(:host)
 end
 
  def build_policies(options)
    mkp = JSON.parse(options["mkp"])
    com = []
    if options[:appname] != nil && options[:servicename] != nil
      value = {
        :name=>"bind policy",
        :ptype=>"colocated",
        :members=>[
          "#{options[:name]}.#{options[:domain]}/#{options[:appname]}",
          "#{options[:name]}.#{options[:domain]}/#{options[:servicename]}"
        ]
      }
    com << value
    end unless mkp["cattype"] == Assemblies::DEW
    com
  end

  #wade out the nils in the assemblys_collection.
  #the error objects shouldn't be in here, but we swallow an exception for an assemblies.list.
  #hence we prune errors as well.
  def prune
    assembly_collection.take_while do |one_assembly|
      one_assembly.components.take_while do |one_component|
        one_component.prune
      end unless (one_component.nil? || one_component.is_a?(Megam::Error))
    end unless (one_assembly.nil? || one_assembly.is_a?(Megam::Error))
  end

  private

  def dig_components(tmp_assembly_collection)
    tmp_assembly_collection.map do |one_assembly|
      one_assembly.components.map do |one_component|
        if !one_component.empty?
          Components.show(one_component).components
        else
          nil
        end
      end
    end
  end

end
