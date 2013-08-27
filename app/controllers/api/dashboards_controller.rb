module Api
  class DashboardsController 
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

  end
end