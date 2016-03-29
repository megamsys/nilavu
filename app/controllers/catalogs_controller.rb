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


  before_action :add_authkeys_for_api, only: [:index, :create, :kelvi, :destroy]

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

    def kelvi
      @msg = { title: "Destroy #{params['cattype'].downcase}", message: "Do you want to destroy #{params['name']} ", redirect: catalog_path(:id => 1, :params => params)}
  end

  def destroy
    Api::Requests.new.reqs(params)
    @msg = { message: "Your  #{params['cattype'].downcase} #{params['name']} is getting nuked"}
  end
end
