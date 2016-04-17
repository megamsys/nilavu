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
  class Components < ApiDispatcher

    attr_reader :components
    def initialize
      @components = []
      super(true)
    end

    def show(api_params, &_block)
      @components = api_request(COMPONENTS, SHOW, api_params)[:body]
      yield self if block_given?
      self
    end

    def update(api_params, &_block)
      api_params["component"] = JSON.parse(api_params["component"])
      bind_type = api_params[:bind_type] if api_params.key?(:bind_type)
      id = api_params["component"]["id"]
      param = bld_update_params(bld_params(api_params["component"], bind_type, id))
      apiparam = api_params.merge(param)
      apiparam[:component][:envs] = []
      apiparam[:envs] = []    
      api_request(COMPONENTS, UPDATE, apiparam)
      yield self if block_given?
      self
    end

    def bld_update_params(api_params)
      Megam::Mixins::Components.new(api_params).to_hash
    end

    def update_exist(api_params, &_block)
      bind_type = "#{api_params[:assemblyname]}/#{api_params[:component][:name]}:#{api_params[:assemblyID]}:#{api_params[:component][:id]}"
      id = api_params[:bind_type].split(":").last
      param = bld_update_params(bld_params({}, bind_type, id))
      apiparam = api_params.merge(param)
      apiparam[:component][:envs] = []
      api_request(COMPONENTS, UPDATE, apiparam)
      yield self if block_given?
      self
    end

    def bld_params(hash, bindtype, id)
      hash.merge({
        :bind_app_flag => 'true',
        :bind_type => bindtype,
        :id => id,
      })
    end 
  end
end
