##
## Copyright [2013-2015] [Megam Systems]
##
## Licensed under the Apache License, Version 2.0 (the "License");
## you may not use this file except in compliance with the License.
## You may obtain a copy of the License at
##
## http://www.apache.org/licenses/LICENSE-2.0
##
## distributed under the License is distributed on an "AS IS" BASIS,
## WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
## See the License for the specific language governing permissions and
## limitations under the License.
##
class OnetorpedosController < NilavuController
	respond_to :html, :js
	include MarketplaceHelper

	before_action :stick_keys, only: [:show, :index]

	def index
		@assembly=Api::Assembly.new.show(params.merge({"id" => params[:id]})).by_cattypes[Api::Assemblies::TORPEDO]
		@assembly
	end
	
end
