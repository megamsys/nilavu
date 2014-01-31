class CloudDashboardsController < ApplicationController

  respond_to :html
  def index
    breadcrumbs.add "Dashboard", :cloud_dashboards_path
    @user_id = current_user.id
    @dashboards = current_user.cloud_books
    @count = @dashboards.length
  end

  def show
    redirect_to cloud_dashboards_path
  end

end
