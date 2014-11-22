class DashboardsController < ApplicationController
  respond_to :html
  
  def index

  end

  def show

    @id = params[:id]
    @user_id = current_user.id
    @dashboards = current_user.apps
    @count = @dashboards.length
  end

end
