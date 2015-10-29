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
module Api
  class Assemblies < APIDispatch
    include MarketplaceHelper

    attr_reader :assemblies_grouped
    attr_reader :apps, :services

    TORPEDO             =  'TORPEDO'.freeze
    APP                 =  'APP'.freeze
    SERVICE             =  'SERVICE'.freeze
    ANALYTICS           =  'ANALYTICS'.freeze
    MICROSERVICES       =  'MICROSERVICES'.freeze
    COLLABORATION       =  'COLLABORATION'.freeze
    CATTYPES            =  [TORPEDO, APP, SERVICE, MICROSERVICES, ANALYTICS, COLLABORATION]

    START               =  'start'.freeze
    STOP                =  'stop'.freeze
    RESTART             =  'restart'.freeze
    REBOOT              =  'reboot'.freeze
    DESTROY             =  'delete'.freeze
    TERMINATED          =  'Terminated'.freeze
    LAUNCHING           =  'LAUNCHING'.freeze
    SOURCE              = 'source'.freeze
    DOCKERCONTAINER     = 'DockerContainer'.freeze

    def initialize
      @assemblies_grouped = {}
      @apps = []
      @services = []
      super(true) # swallow 404 errors for assemblies.
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
    def list(api_params, &_block)
      raw = api_request(ASSEMBLIES, LIST, api_params)
      dig_assembly(raw[:body], api_params) unless raw.nil?
      @apps = flying_apps(APP) unless api_params[:flying_apps].nil?
      @services = flying_apps(SERVICE) unless api_params[:flying_service].nil?
      yield self  if block_given?
      self
    end

    def create(api_params, &_block)
      api_request(ASSEMBLIES, CREATE,Assemblies.Deployable.new(api_params))
      yield self if block_given?
      self
    end

    private
    # The /assemblies just returns an id of assembly. dig recursively to get the full content of it.
    #     assemblies : :id  => ASM0001
    #          assembly: :id => ASC0001
    #              component :id => CMP0001
    def dig_assembly(tmp_assemblies_collection, api_params)
      # First step A[A[H1], A[H2]] => A[H1, H2..Hn]
      a2 = tmp_assemblies_collection.map do |one_assemblies|
        a1 = one_assemblies.assemblies.map do |one_assembly|
          unless one_assembly.empty?
            Api::Assembly.new.show(api_params.merge(id: one_assembly, asms_id: one_assemblies.id)).by_cattypes

          end
        end
        a1.reduce { |acc, h| acc.merge(h || {}) }
      end
      # A[H1, H2, ... Hn] => H[:CATTYPE => [H1, H2, ... Hn]]
      a3 = a2.group_by { |j| j.keys.join }

      # [:CATTYPE => [H1, H2, ... Hn]] => H[:CATTYPE => [A1, A2]]
      a3.each do |k, v|
        @assemblies_grouped[k] ||= []

        @assemblies_grouped[k] << v.map { |u| u.map { |_k1, v1| v1 } }
      end

      Rails.logger.debug "\033[36m>-- ASB'S: #{@assemblies_grouped.class} START\33[0m"
      Rails.logger.debug "\033[1m#{@assemblies_grouped.to_yaml}\33[22m"
      Rails.logger.debug "\033[36m> ASB'S: END\033[0m"
    end

    # provides the flying apps which is used by the bind app screen.
    def flying_apps(assembly_type)
      tmp_apps = []
      if !@assemblies_grouped.empty? && !@assemblies_grouped[assembly_type].nil?
        @assemblies_grouped[assembly_type].flatten.each do |one_assembly|
          one_assembly.components.flatten.map do |u|
            unless u.nil?
              u.each do |com|
                tmp_apps << { name: "#{one_assembly.name}.#{parse_key_value_pair(com.inputs, 'domain')}/#{com.name}", aid: one_assembly.id, cid: com.id }
              end
            end
          end
        end
      end
      tmp_apps
    end
  end
end
