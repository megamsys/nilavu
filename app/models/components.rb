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
require 'json'

class Components < BaseFascade

  attr_reader :components

  def initialize()
    @components= nil
    @name = nil
    @tosca_type = nil
    @inputs = []
    @related_components = []
    @operations = []
  end

  def show(api_params, &block)
    @components = api_request(api_params, COMPONENTS, SHOW)[:body]
    yield self if block_given?
    return self
  end

  def update(api_params, &block)
    api_request(bld_update_params(api_params), COMPONENTS, UPDATE)
    yield self if block_given?
    return self
  end

#FOR BIND APP
  def update_exist(api_params, &block)
    api_request(bld_exist_update_params(api_params), COMPONENTS, UPDATE)
    api_request(bld_exist_alter_update_params(api_params), COMPONENTS, UPDATE)#FOR BIND APP
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
    set_microservice_params(params) if mkp["cattype"] == Assemblies::MICROSERVICES
    set_common_inputs(params)
    set_operations(params)

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
      "status" => Assemblies::LAUNCHING
    }]
    hash
  end

  def bld_update_params(params)
    com = empty_component
    com["related_components"] << "#{params[:assemblyname]}.#{params[:domain]}/#{params[:componentname]}" if params.has_key?(:bind_type)
    com[:email] = params["email"]
    com[:api_key] = params["api_key"]
    com["id"] = "#{params[:bind_type].split(':')[2]}"
    com
  end
#FOR BIND APP
#{"utf8"=>"✓", "bind_type"=>"sensational.megambox.com/adverb:ASM1218262452991557632:COM1218262453004140544", "bindapp"=>"shinier.megambox.com/intoxicated:ASM1218262384012034048:COM1218262384024616960", "commit"=>"Bind", "controller"=>"oneapps", "action"=>"bind_service", "email"=>"4@4.com", "api_key"=>"Ovs1GukrrQC4Z8rgM0hu0g==", "host"=>"localhost"}

  def bld_exist_update_params(params)
    com = empty_component
    com["related_components"] << "#{params[:bind_type].split(':')[0]}" if params.has_key?(:bind_type)
    com[:email] = params["email"]
    com[:api_key] = params["api_key"]
    com["id"] = "#{params[:bindapp].split(':')[2]}"
    com
  end

  def bld_exist_alter_update_params(params)
    com = empty_component
    com["related_components"] << "#{params[:bindapp].split(':')[0]}" if params.has_key?(:bindapp)
    com[:email] = params["email"]
    com[:api_key] = params["api_key"]
    com["id"] = "#{params[:bind_type].split(':')[2]}"
    com
  end

private

  def empty_component
    {
      "name"              => nil,
      "tosca_type"        => nil,
      "inputs"            => [],       # fields - domain, port, username, password, version, source, design_inputs { id, x, y, z, wires }, service_inputs: { dbname, dbpassword}
      "outputs"           => [],
      "artifacts" => {
        "artifact_type" => "",
        "content" => "",
        "artifact_requirements" => []
      },
      "related_components" => [],
      "operations" =>  [],
      "status" => nil
    }
  end

  def set_app_params(params)
    mkp = JSON.parse(params["mkp"])
    @name = params[:componentname]
    @tosca_type = "tosca.#{mkp["cattype"].downcase}.#{mkp["predef"]}"
  end

  def set_service_params(params)
    mkp = JSON.parse(params["mkp"])
    @name = params[:componentname]
    @tosca_type = "tosca.#{mkp["cattype"].downcase}.#{mkp["predef"]}"
    set_postgres_inputs(params) unless mkp["predef"] != "postgresql"
    @related_components << "#{params[:bind_type].split(':')[0]}" if params.has_key?(:bind_type)
  end

  def set_microservice_params(params)
    mkp = JSON.parse(params["mkp"])
    @name = params[:componentname]
    @tosca_type = "tosca.#{mkp["cattype"].downcase}.#{mkp["predef"]}"
  end

  #the common inputs method set all components(apps, service, microservices..)
  def set_common_inputs(params)
    @inputs << {"key" => "domain", "value" => params[:domain]} if params.has_key?(:domain)
    @inputs << {"key" => "port", "value" => params[:port]} if params.has_key?(:port)
    @inputs << {"key" => "version", "value" => params[:version]} if params.has_key?(:version)
    @inputs << {"key" => "source", "value" => params[:source]} if params.has_key?(:source)
  end

  def set_postgres_inputs(params)
    mkp = JSON.parse(params["mkp"])    
    @inputs << {"key" => "username", "value" => params["email"]}
    @inputs << {"key" => "password", "value" => params["api_key"]}
    @inputs << {"key" => "dbname", "value" => params["componentname"]}
    @inputs << {"key" => "dbpassword", "value" => ('a'..'z').to_a.shuffle.first(8).join }
    @inputs << {"key" => "port", "value" => mkp["catalog"]["port"]}
  end 

  #set user operations for components like (continous integration)
  def set_operations(params)
     set_ci_operation(params) if params["check_ci"] == "true"
  end

  def set_ci_operation(params)
    @operations << {
        "operation_type" => "CI",
        "description" => "Continous Integration",
        "operation_requirements" => bld_ci_requirements(params),
    }
  end

  def bld_ci_requirements(params)
    op = []
    op <<  {"key" => "ci-scm", "value" => params["scm_name"]}
    op <<  {"key" => "ci-enable","value" => "true"}
    op <<  {"key" => "ci-token","value" => params["scmtoken"]}
    op <<  {"key" => "ci-owner","value" => params["scmowner"]}
    op <<  {"key" => "ci-url", "value" => params["scm_url"]}
    op <<  {"key" => "ci-apiversion", "value" => params["scm_version"]}
    op
  end

end
