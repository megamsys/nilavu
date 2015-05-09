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
class CatalogsController < ApplicationController
  respond_to :html, :js
  include Pilotable

  before_action :stick_keys, only: [:index, :create, :destroy]

  #This is essentially a filtered view of cattype [ADDON, APP, DEW,SERVICE] the cockpit.
  #Invoked when you click Apps, Services, Addons from the left nav.
  def index
    @catname = params[:cattype].capitalize
    assem = Assemblies.new.list(params)
    @assemblies_grouped = assem.assemblies_grouped
  end

end
