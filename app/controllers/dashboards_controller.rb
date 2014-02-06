class DashboardsController < ApplicationController
  respond_to :html
  
  def index
    breadcrumbs.add "Home", "#", :target => "_self"
    breadcrumbs.add "Performance Monitoring Console", cloud_dashboards_path, :target => "_self"
  end

  def show
    breadcrumbs.add "Overview", "#overview"  
    breadcrumbs.add "Processes", "#processes"
    breadcrumbs.add "Networks", "#network"
    breadcrumbs.add "Disks", "#"
    @id = params[:id]
    @user_id = current_user.id
    @dashboards = current_user.cloud_books
    @count = @dashboards.length
  end

end
