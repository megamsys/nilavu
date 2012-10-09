class ConnectorProjectsController < ApplicationController

 def index
     if !current_user.organization
      flash[:error] = "Please Create Organization Details first"
      redirect_to edit_user_path(current_user)
     elsif !current_user.organization.cloud_app
      flash[:error] = "Please Add any cloud Applications"
      redirect_to cloud_app_path(current_user.id)
     end
     @connector_project = ConnectorProject.find(params[:id])
    
 end

 def new 
    @connector_project = ConnectorProject.new
    logger.debug "Connector Project = #{@connector_project}"
    #@connector_project.build_connector_actions
    #@connector_project.connector_output.build
    @products = Product.all
    @apps_item = current_user.organization.cloud_app.apps_items 
 end

 def create
    @connector_project = ConnectorProject.new(params[:connector_project])
    
    if @connector_project.save
      flash[:success] = "Connector Created."
      @products = Product.all
      @apps_item = current_user.organization.cloud_app.apps_items
      #redirect_to customizations_show_url
      render 'index'
    end
 end
end
