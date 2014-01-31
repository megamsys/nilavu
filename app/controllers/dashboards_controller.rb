class DashboardsController < ApplicationController
  respond_to :html
  def index
    breadcrumbs.add "Dashboard", dashboards_path
    @user_id = current_user.id
  end

  def show
    breadcrumbs.add "Dashboard", dashboards_path
    redirect_to dashboards_path
  end

end
