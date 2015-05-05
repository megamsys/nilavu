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
class CockpitsController < ApplicationController
  respond_to :html, :js

  before_action :stick_keys, only: [:index]

  #doesn't require a sign for new and create action, hence skip it.
  skip_before_action :require_signin, only: [:varai]

  #doesn't require to catch execption for show
  skip_around_action :catch_exception, only: [:show]

  #RAJ, we may not use apps_spun, vm_spun i think
  def index
    logger.debug "> Cockpits: index."
    assem = Assemblies.new.list(params)
    assem.assemblies
    assem.apps_spun
    assem.dews_spun
    assem.services_spun
  end

  def show
    redirect_to cockpits_path and return
  end

  def varai
    redirect_to cockpits_path, :gflash => { :error => { :value => "Invalid username and password combination, Please Enter your correct megam email", :sticky => false, :nodom_wrap => true } }
  end

end
