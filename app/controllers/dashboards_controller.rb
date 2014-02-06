class DashboardsController < ApplicationController
  respond_to :html

  def index
    breadcrumbs.add "Dashboard", :cloud_dashboards_path
  end

  def show
    @id = params[:id]
    @user_id = current_user.id
    @dashboards = current_user.cloud_books
    @count = @dashboards.length
  end

end
