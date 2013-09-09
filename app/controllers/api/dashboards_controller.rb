module Api
  class DashboardsController < ApplicationController
    respond_to :json, :html
    def show
      puts("------show ------------->> entry")
      dashboard = Dashboard.find(params[:id])
      respond_with dashboard
    end

    def index
      puts("------index ------------->> entry")
      dashboards = Dashboard.order("NAME ASC").all
      respond_with dashboards
    end

    def create
      puts("---------create---------->> entry")
      input = JSON.parse(request.body.read.to_s)
      dashboard = Dashboard.new(input.slice(*Dashboard.accessible_attributes))
      if dashboard.save
        render :json => dashboard, :status => :created, :location => api_dashboards_url(dashboard)
      else
        render :json => dashboard.errors, :status => :unprocessable_entity
      end
    end

    def update
      puts("------------------->> update")
      dashboard = Dashboard.find(params[:id])
      puts ("---------------> update #{params}")
      input = JSON.parse(request.body.read.to_s)
      puts ("--------------> input #{input}")
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