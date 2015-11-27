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
class OneappsController < NilavuController
	respond_to :html, :js
	include OneoverHelper
	include CatalogHelper

	before_action :stick_keys, only: [:index, :show, :create]

	def index
		@assembly = Api::Assembly.new.show(params.merge('id' => params[:id])).by_cattypes[Api::Assemblies::APP]
		@bound_services = bound_assemblies(Api::Assemblies.new.list(params).assemblies_grouped[Api::Assemblies::SERVICE], @assembly.components[0][0].components.related_components)
	end

	def show
		@bindapp = params[:id]
		@service = unbound_apps(Api::Assemblies.new.list(params.merge(flying_service: 'true')).services)
		respond_to do |format|
			format.js { respond_with(@bindapp, @service, layout: !request.xhr?) }
		end
	end

	def create
		puts "*******************"
		puts params
		params[:bind_app_flag] = 'true'
		binded_service?(params) do
			Api::Assembly.new.update(params)
			Api::Components.new.update(params)
			Api::Components.new.update_exist(params)
		end if params.key?(:bind_type)
		toast_success(cockpits_path, "#{params['action'].camelize} #{params['assemblyname']}.#{params['domain']} submitted successfully. ")
		@msg = { title: 'Bind Service'.downcase.camelize, message: 'Service bounded successfully. ', redirect: '/', disposal_id: 'bindservice' }
	end

	private

	def binded_service?(params, &_block)
		yield if block_given? unless params[:bind_type].eql?('Unbound app')
	end
end
