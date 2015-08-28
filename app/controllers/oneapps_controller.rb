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
class OneappsController < ApplicationController
  respond_to :html, :js
  include OneappsHelper
  include CatalogHelper

  before_action :stick_keys, only: [:index, :bind_service_list, :bind_service]

  def index
    @assembly = Assembly.new.show(params.merge({"id" => params[:id]})).by_cattypes[Assemblies::APP]
    @bound_services = bound_assemblies(Assemblies.new.list(params).assemblies_grouped[Assemblies::SERVICE], @assembly.components[0][0].components.related_components)
    @assembly
  end

  def bind_service_list
	@bindapp = params[:bindapp]
	@service = unbound_apps(Assemblies.new.list(params.merge(:flying_service=> "true")).services) 
  end

  def bind_service

params[:bind_app_flag]="true"

    binded_service?(params) do
      Assembly.new.update(params)
      Components.new.update(params)
      Components.new.update_exist(params)
    end if params.key?(:bind_type)

 @msg = { title: "Bind Service".downcase.camelize, message: "Service bounded successfully. ", redirect: '/', disposal_id: 'bindservice' }

  end

  private

  def binded_service?(params, &_block)
     yield if block_given? if !params[:bind_type].eql?('Unbound app')
  end

end
