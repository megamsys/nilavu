##
## Copyright [2013-2016] [Megam Systems]
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
  class Assembly < ApiDispatcher
    include MarketplaceHelper

    attr_reader :by_cattypes
    attr_reader :tosca_type
    attr_reader :components

    DEFAULT_TOSCA_PREFIX = 'tosca'.freeze
    # this is a mutable string, if nothing exists then we use ubuntu
    DEFAULT_TOSCA_SUFFIX = 'ubuntu'.freeze
    def initialize
      @by_cattypes = {}
      @inputs = []
      @components = []
      @app_list = []
    end

    def show(api_params, &_block)
      raw = api_request(ASSEMBLY, SHOW, api_params)
      dig_components(raw[:body], api_params)
      yield self if block_given?
      self
    end

    def update(api_params, &_block)
      api_request(ASSEMBLY, UPDATE, api_params) if api_params.key?(:bind_app_flag) # FOR BIND APP
      yield self if block_given?
      self
    end
        def upgrade(api_params, &_block)
      api_request(ASSEMBLY, UPGRADE, api_params.merge(bld_upgrade_params(api_params)))
      yield self if block_given?
      self
    end

    private
        def bld_upgrade_params(api_params)
      Megam::Mixins::Assembly.new(api_params).to_hash
    end

    # recursively dig assembly by populating components.
    def dig_components(tmp_assembly_collection, api_params)
      tmp_assembly_collection.map do |one_assembly|
        a0 = one_assembly.components.map do |one_component|
          unless one_component.empty?
            one_component = Components.new.show(api_params.merge('id' => one_component)).components
          end
        end
        one_assembly.asms_id(api_params[:asms_id])
        # set the_id in assembly. we need it for destroy
        one_assembly.components.replace(a0)
        @by_cattypes = @by_cattypes.merge(want_catkey(one_assembly.tosca_type) => one_assembly)
      end
      Rails.logger.debug '>-- ASC: START'
      Rails.logger.debug "#{@by_cattypes}"
      Rails.logger.debug '> ASC: END'
    end

    # match the tosca type APP, SERVICE, MICROSERVICES, TORPEDO from the string tosca.dew.ubuntu.
    # if there is no match, then send out an error
    def want_catkey(tmp_tosca_type)
      c0 = Api::Assemblies::CATTYPES.select { |cat| cat unless cat.downcase != tmp_tosca_type.split('.')[1] }
      fail MissingAPIArgsError, "Supported cat types are #{CATTYPES}." if c0.nil?
      c0.join
    end
  end
end
