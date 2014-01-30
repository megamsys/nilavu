class CloudDashboardsController < ApplicationController
  
  respond_to :html

  add_breadcrumb "Dashboard", :cloud_dashboards_path
  def index
    @user_id = current_user.id
    @dashboards = current_user.cloud_books 
    @count = @dashboards.length
  end

  def show
    redirect_to cloud_dashboards_path
  end
  
end
