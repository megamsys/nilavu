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
  class DashboardsController < ApplicationController
    respond_to :json, :html
    def show
      #dashboard = Dashboard.find(params[:id])
      dashboard = App.find(params[:id])
      respond_with dashboard
    end

    def index
      @user_id = current_user["email"]
      #dashboards = current_user.apps
      respond_with @user_id
    end

    def dash_show
   #   @user_id = current_user.id
   #   dashboards = current_user.apps
    #  respond_with dashboards
    end

    def create
      input = JSON.parse(request.body.read.to_s)
      dashboard = Dashboard.new(input.slice(*Dashboard.accessible_attributes))
      if dashboard.save
        render :json => dashboard, :status => :created, :location => api_dashboards_url(dashboard)
      else
        render :json => dashboard.errors, :status => :unprocessable_entity
      end
    end

    def update
      dashboard = App.find(params[:id])
      input = JSON.parse(request.body.read.to_s)
      if dashboard.update_attributes(input.slice(*Dashboard.accessible_attributes))
        render :json => dashboard
      else
        render :json => dashboard.errors, :status => :unprocessable_entity
      end
    end

    def destroy
      Dashboard.destroy(params[:id])
      head :no_content
    end

  end
end