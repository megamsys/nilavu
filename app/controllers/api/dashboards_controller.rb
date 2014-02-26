module Api
  class DashboardsController < ApplicationController
    respond_to :json, :html
    def show
      #dashboard = Dashboard.find(params[:id])
      dashboard = CloudBook.find(params[:id])
      respond_with dashboard
    end

    def index
      @user_id = current_user.id
      dashboards = current_user.apps
      respond_with dashboards
    end

    def dash_show
      @user_id = current_user.id
      dashboards = current_user.apps
      respond_with dashboards
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
      dashboard = CloudBook.find(params[:id])
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