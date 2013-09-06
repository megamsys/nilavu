class WidgetsController < ApplicationController
  respond_to :html, :js, :json

  add_breadcrumb "Dashboard", :dashboards_path
  
   def show
      #logger.debug ("-W------show---- #{params}")
      widget = Widget.for_dashboard(params[:dashboard_id]).find(params[:id])
      respond_with(widget)
    end

    def index
      #logger.debug ("-W----show------ #{params}")
      puts "============widget model"
      puts for_dashboard(params[:dashboard_id])
      widgets = Widget.for_dashboard(params[:dashboard_id]).all
      respond_with(widgets)
    end
  
end
