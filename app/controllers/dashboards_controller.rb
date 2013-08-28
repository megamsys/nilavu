class DashboardsController < ApplicationController
  respond_to :html, :js

  add_breadcrumb "Dashboard", :dashboards_path
  
    def show
      puts("------show ------------->> entry")
      dashboard = Dashboard.find(params[:id])
      respond_with dashboard
    end

    def index
      puts("------index ------------->> entry")
      #dashboards = Dashboard.order("NAME ASC").all
      dashboards = Dashboard.all
      respond_with dashboards
    end
end
