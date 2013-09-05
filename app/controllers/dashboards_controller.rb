class DashboardsController < ApplicationController
  respond_to :json

  
  
    def show
      add_breadcrumb "Dashboard", :dashboard_path
      puts("------show ------------->> entry")
      dashboard = Dashboard.find(1)
      #respond_with dashboard
    end

    def index
     # puts("------index ------------->> entry")
      #dashboards = Dashboard.order("NAME ASC").all
     # dashboards = Dashboard.all
      #respond_with dashboards
    end
end
