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

class Components < BaseFascade

  attr_reader :components

  def initialize()
    @components= nil
    @name = nil
    @tosca_type = nil
    @inputs = []
    @related_components = nil
    @operations = []
  end

  def show(api_params, &block)
    @components = api_request(api_params, COMPONENTS, SHOW)[:body]
    yield self if block_given?
    return self
  end

  def prune
    components.take_while { |one_component| (one_component.nil? || one_component.is_a?(Megam::Error)) }
  end

  def build(params)
    com = []
    mkp = JSON.parse(params["mkp"])

    set_app_params(params) if mkp["cattype"] == Assemblies::APP
    set_service_params(params) if mkp["cattype"] == Assemblies::SERVICE
    set_addon_params(params) if mkp["cattype"] == Assemblies::ADDON
    set_common_inputs(params)

    hash = [{
      "name"              => @name,
      "tosca_type"        => @tosca_type,
      "inputs"            => @inputs,       # fields - domain, port, username, password, version, source, design_inputs { id, x, y, z, wires }, service_inputs: { dbname, dbpassword}
      "outputs"           => [],
      "artifacts" => {
        "artifact_type" => "",
        "content" => "",
        "artifact_requirements" => []
      },
      "related_components" => @related_components,
      "operations" =>  @operations,
      "status" => Assembly::STATUS
    }]
    hash
  end

  def set_app_params(params)
    mkp = JSON.parse(params["mkp"])
    @name = params[:appname]
    @tosca_type = "tosca.#{mkp["cattype"].downcase}.#{mkp["predef"]}"
  end

  def set_service_params(params)
    mkp = JSON.parse(params["mkp"])
    @name = params[:servicename]
    @tosca_type = "tosca.#{mkp["cattype"].downcase}.#{mkp["predef"]}"
    set_postgres_inputs(params) unless mkp["predef"] != "postgresql"
  end

  def set_addon_params(params)
    mkp = JSON.parse(params["mkp"])
    @name = params[:appname]
    @tosca_type = "tosca.#{mkp["cattype"].downcase}.#{mkp["predef"]}"
  end

  #the common inputs method set all components(apps, service, addons..)
  def set_common_inputs(params)
    @inputs << {"key" => "domain", "value" => params[:domain]} if params.has_key?(:domain)
    @inputs << {"key" => "port", "value" => params[:port]} if params.has_key?(:port)
    @inputs << {"key" => "version", "value" => params[:version]} if params.has_key?(:version)
    @inputs << {"key" => "source", "value" => params[:source]} if params.has_key?(:source)
  end

  def set_postgres_inputs(params)
    @inputs << {"key" => "username", "value" => params["email"]}
    @inputs << {"key" => "password", "value" => params["api_key"]}
    @inputs << {"key" => "dbname", "value" => params["email"]}
    @inputs << {"key" => "dbpassword", "value" => ('0'..'z').to_a.shuffle.first(8).join }
  end

  #set user operations for components like (continous integration)
  def set_operations(params)

  end

end
