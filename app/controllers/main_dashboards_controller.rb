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
class MainDashboardsController < ApplicationController
  respond_to :html, :js

  before_action :stick_keys, only: [:index]

  #doesn't require a sign for new and create action, hence skip it.
  skip_before_action :require_signin, only: [:varai]

  #doesn't require to catch execption for show
  skip_around_action :catch_exception, only: [:show]

  def index
    logger.debug ">----- index."
    logger.debug ">----- #{params}"
    assem = Assemblies.new.list(params)
    assem.assemblies
    assem.apps_spun
    assem_vms_spun
    assem_services_spun
  end

  def varai
      redirect_to main_dashboards_path, :gflash => { :error => { :value => "Invalid username and password combination, Please Enter your correct megam email", :sticky => false, :nodom_wrap => true } }
  end

  def show
    redirect_to main_dashboards_path and return
  end

  #
  ## Lifecycle of the app, services and VMs  - start, stop, restart and delete.
  #

  def lifecycle
    @a_id = params[:id]
    @a_name = params[:name]
    @command = params[:command]
    @launch_type = params[:type]
    options = {:a_id => "#{params[:id]}", :a_name => "#{params[:name]}", :command => "#{params[:command]}", :launch_type => "#{params[:type]}"  }
    create_events = CreateEvent.perform(options, force_api[:email], force_api[:api_key])
    respond_to do |format|
      format.js {
        respond_with(@a_id, @a_name, @command, @launch_type, :layout => !request.xhr? )
      }
    end
  end

  def deleteapp
    @id = params[:id]
    @name = params[:name]
    respond_to do |format|
      format.js {
        respond_with(@id, @name, :layout => !request.xhr? )
      }
    end
  end

  def delete_request
    logger.debug "--> Apps:Delete_request, #{params}"
    options = {:app_id => "#{params[:app_id]}", :app_name => "#{params[:app_name]}", :action => "#{params[:command]}"}
    defnd_result = CreateRequests.perform(options, force_api[:email], force_api[:api_key])
    if params[:command] == "delete"
      @res_msg = "App #{params[:command]}ed successfully"
    end
    @err_msg = nil
    if defnd_result.class == Megam::Error
      @res_msg = nil
      @err_msg = ActionController::Base.helpers.link_to 'Contact Support', "http://support.megam.co/"
      respond_to do |format|
        format.js {
          respond_with(@res_msg, @err_msg, :layout => !request.xhr? )
        }
      end
    end
  end

  def lifecycle_request
    logger.debug "--> Apps:Build_request, #{params}"
    options = {:app_id => "#{params[:app_id]}", :app_name => "#{params[:app_name]}", :action => "#{params[:command]}"}
    defnd_result =  CreateAppRequests.perform(options, force_api[:email], force_api[:api_key])
    if params[:command] == "stop"
      @res_msg = "App #{params[:command]}ped successfully"
    else
      @res_msg = "App #{params[:command]}ed successfully"
    end
    @err_msg = nil
    if defnd_result.class == Megam::Error
      @res_msg = nil
      @err_msg= ActionController::Base.helpers.link_to 'Contact support ', "http://support.megam.co/"
      respond_to do |format|
        format.js {
          respond_with(@res_msg, @err_msg, :layout => !request.xhr? )
        }
      end
    end
  end

  def delete_request
    logger.debug "--> Apps:Delete_request, #{params}"
    options = {:node_id => "#{params[:app_id]}", :node_name => "#{params[:app_name]}", :req_type => "#{params[:command]}"}
    defnd_result = CreateRequests.perform(options, force_api[:email], force_api[:api_key])
    if params[:command] == "delete"
      @res_msg = "App #{params[:command]}d successfully"
    end
    @err_msg = nil
    if defnd_result.class == Megam::Error
      @res_msg = nil
      @err_msg = ActionController::Base.helpers.link_to 'Contact Support', "http://support.megam.co/"
      respond_to do |format|
        format.js {
          respond_with(@res_msg, @err_msg, :layout => !request.xhr? )
        }
      end
    end
  end

  private

  def main_dashboard_params
    params.require(:main_dashboard).permit(:first_name, :last_name, :admin, :phone, :onboarded_api, :user_type, :email, :api_token, :password, :password_confirmation, :verified_email, :verification_hash, :app_attributes, :cloud_identity_attributes, :apps_item_attributes)
  end

end
