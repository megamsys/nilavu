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
  class Components < APIDispatch
    attr_reader :components

    def initialize
    end

    def show(api_params, &_block)
      @components = api_request(COMPONENTS, SHOW,api_params)[:body]
      yield self if block_given?
      self
    end

    def update(api_params, &_block)
      api_request(COMPONENTS, UPDATE, bld_update_params(api_params))
      yield self if block_given?
      self
    end

    def update_exist(api_params, &_block)
      #    api_request(bld_exist_update_params(api_params), COMPONENTS, UPDATE)
      #    api_request(bld_exist_alter_update_params(api_params), COMPONENTS, UPDATE) # FOR BIND APP
      yield self if block_given?
      self
    end
    #    def set_postgres_inputs(params)
    #    mkp = JSON.parse(params['mkp'])
    #    @inputs << { 'key' => 'username', 'value' => params['email'] }
    #    @inputs << { 'key' => 'password', 'value' => params['api_key'] }
    #    @inputs << { 'key' => 'dbname', 'value' => params['componentname'] }
    #    @inputs << { 'key' => 'dbpassword', 'value' => ('a'..'z').to_a.sample(8).join }
    #    @inputs << { 'key' => 'port', 'value' => mkp['catalog']['port'] }
    #    end
  end
end
