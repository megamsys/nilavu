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
  attr_reader :by_cattypes
  attr_reader :tosca_type
  attr_reader :components

  DEFAULT_TOSCA_PREFIX = 'tosca'.freeze
  #this is a mutable string, if nothing exists then we use ubuntu
  DEFAULT_TOSCA_SUFFIX = 'ubuntu'.freeze


  def initialize()
    @assembly_collection= nil
    @by_cattypes = {}
    @inputs = []
    @requirements = []
    @components = []
  end

  def show(api_params, &block)
    raw = api_request(api_params, ASSEMBLY, SHOW)
    @assembly_collection =  dig_components(raw[:body])
    yield self  if block_given?
    return self
  end

 def build(params)
  mkp = JSON.parse(params["mkp"])

  bld_toscatype(mkp)
  bld_components(params) unless mkp["cattype"] == Assemblies::DEW
  bld_requirements(params)
  bld_inputs(params)

  [{
      "name"=>"#{params[:name]}",
      "tosca_type"=> "#{tosca_type}",
      "components"=> components,
      "requirements"=> @requirements,
      "policies"=>bld_policies(params),
      "inputs"=> @inputs,
      "outputs"=>[],
      "operations"=>[],
      "status"=> Assemblies::LAUNCHING,
        }]

 end



 private

 def bld_toscatype(mkp)
   tosca_suffix = DEFAULT_TOSCA_SUFFIX
   tosca_suffix = "#{mkp["predef"]}" unless mkp["cattype"] != Assemblies::DEW
   @tosca_type = DEFAULT_TOSCA_PREFIX +  ".#{mkp["cattype"].downcase}.#{tosca_suffix}"
 end

 ##For a vm, there is no component to start with, hence this is skipped.
 def bld_components(params)
   @components = Components.new.build(params)
 end

 #In future lot of requirements add this method
 def bld_requirements(params)
   @requirements << {"key" => "host", "value" => params[:host]} if params.has_key?(:host)
 end


def bld_policies(params)
    mkp = JSON.parse(params["mkp"])
    com = []
    if params[:appname] != nil && params[:servicename] != nil
      value = {
        :name=>"bind policy",
        :ptype=>"colocated",
        :members=>[
          "#{params[:name]}.#{params[:domain]}/#{params[:appname]}",
          "#{params[:name]}.#{params[:domain]}/#{params[:servicename]}"
        ]
      }
    com << value
    end unless mkp["cattype"] == Assemblies::DEW
    com
  end

  #In future lot of inputs add this method
  def bld_inputs(params)
    @inputs << {"key" => "sshkey", "value" => params[:ssh_key_name]} if params[:ssh_key_name]
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


  def dig_components(tmp_assembly_collection)
    tmp_assembly_collection.map do |one_assembly|
       a0 = one_assembly.components.map do |one_component|
        if !one_component.empty?
          one_component = Components.new.show(api_params.merge({"id" => one_component})).components
        else
          nil
        end
      end
      one_assembly.components.replace(a0)
      @by_cattypes[Assemblies::CATTYPES.select {|catt|  catt if one_assembly.tosca_type.match(catt.downcase)}] = one_assembly
    end
    Rails.logger.debug ">-- ASC: START"
    Rails.logger.debug "#{@by_cattypes.inspect}"
    Rails.logger.debug "> ASC: END"
    tmp_assembly_collection
  end

end
