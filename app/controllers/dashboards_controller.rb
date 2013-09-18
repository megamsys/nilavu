class DashboardsController < ApplicationController
   respond_to :html
   
   add_breadcrumb "Dashboard", :dashboards_path
  def index
      puts("------rails index ------------->> entry")
      @user_id = current_user.id
      #dashboards = Dashboard.order("NAME ASC").all
      #respond_with dashboards
    end
  
end
