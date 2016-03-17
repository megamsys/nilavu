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
##
# A mixin that can be used for controls operations like
#  create:
#          - CREATE  lifecyle ops like START, STOP, RESTART, DELETE which submits /catrequests to gateway
#  destroy:
#          - DESTROY an assembly  or catalog.
#            this action gets called prior to a start, stop, restart, delete operation
#            a confirmation is got from the user to perform the same.
class CatalogsController < ApplicationController
  include CatalogHelper
  respond_to :html, :js

  before_action :add_authkeys_for_api, only: [:index,:create,:destory,:kelvi]

  #A filtered view of cattype [MICROSERVICES, APP, TORPEDO,SERVICE] the cockpit.
  #This action is invoked when you click Apps, Services, Addons from the left nav.
  def index
    logger.debug "> Pilotable: Index"
    @cattype = params[:cattype].capitalize
    @assemblies_grouped = Api::Assemblies.new.list(params).assemblies_grouped
  end

  #this action performs a start, stop, restart operation
  def create
    logger.debug "> Pilotable: create"
    Api::Requests.new.reqs(params.merge({:action => params[:req_action]}))
    @msg = { message: "#{params['name']}",
    title: "#{params['req_action'].camelize}ing #{params['cattype'].downcase}"}
  end

  #a confirmation question for a delete operation.
  def kelvi
    logger.debug "> Pilotable: kelvi"
    @msg = { title: "Destroy #{params['cattype'].downcase}", message: "Do you want to destroy #{params['name']} ", redirect: catalog_path(:id => 1, :params => params)}
  end

  #this action performs a delete operation.
  def destroy
    logger.debug "> Pilotable: destroy"
    Api::Requests.new.reqs(params)
    redirect_to(cockpits_path, :flash => { :success => I18n.t('"Your  #{params['cattype'].downcase} #{params['name']} is getting nuked"', :title => "#{params['req_action']}ing #{params['cattype'].downcase}")}, format: 'js')
  end

  def runtime
    logger.debug "> Pilotable: Runtime"
    asm = Assembly.new.show(params).by_cattypes
    @cattype = params["cattype"]
    @appname = parse_key_value_json(asm['#{params["cattype"]}'].components[0][0].outputs, "id") if params["cattype"] == Api::Assemblies::MICROSERVICES
    @host = parse_key_value_json(asm['#{params["cattype"]}'].components[0][0].outputs, "host") if params["cattype"] == Api::Assemblies::MICROSERVICES
    @host = "" unless params["cattype"] == Api::Assemblies::MICROSERVICES
    @appname = asm['"#{params["cattype"]}'].name + "." + parse_key_value_json(asm['#{params["cattype"]}'].inputs, "domain") unless params["cattype"] == Api::Assemblies::MICROSERVICES
  end

  def logs
    logger.debug "> Pilotable: Logs"
    asm = Assembly.new.show(params).by_cattypes
    @appname = asm["#{params['cattype']}"].name + "." + parse_key_value_json(asm["#{params['cattype']}"].inputs, "domain")
    @appname
  end
end
