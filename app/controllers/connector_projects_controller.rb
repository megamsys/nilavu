class ConnectorProjectsController < ApplicationController

 def index
     if !current_user.organization
      flash[:error] = "Please Create Organization Details first"
      redirect_to edit_user_path(current_user)
     elsif !current_user.organization.cloud_app
      flash[:error] = "Please Add any cloud Applications"
      redirect_to cloud_app_path(current_user.id)
     end
     
     @connector_project = ConnectorProject.all
     
 end

 def new 
    @connector_project = ConnectorProject.build
    
    #@connector_project.save
    logger.debug "Connector Project = #{@connector_project}"
    #@connector_action = @connector_project.connector_actions.create(:biz_function => "users#create")
    #@connector_output = @connector_project.connector_outputs.create
    
    @products = Product.all
    @apps_item = current_user.organization.cloud_app.apps_items 
    #logger.debug "Connector Action = #{@connector_action}"
 end

 def create
    logger.debug "Connector Project = #{@connector_project}"
    logger.debug "Connector Project = #{:connector_project}"
    @connector_project = ConnectorProject.new(params[:connector_project])
    
    if @connector_project.save
	logger.debug "Connector Project = #{@connector_project}"
      flash[:success] = "Connector project Created with the description #{@connector_project.Description}"
      @products = Product.all
      @apps_item = current_user.organization.cloud_app.apps_items
	@connector_project = ConnectorProject.all
      redirect_to connector_projects_path
      #render 'index'
      
    end
 end

 def show
 	@connector_project = ConnectorProject.find(params[:id])
	@products = Product.all
        @apps_item = current_user.organization.cloud_app.apps_items
	#render 'new'
 end

 def update
    @connector_project = ConnectorProject.find(params[:id])
    if @connector_project.update_attributes(params[:connector_project])
      flash[:success] = "Connector_Project #{@connector_project.Description} updated"
      @connector_project = ConnectorProject.all
      redirect_to connector_projects_path
    end
  end

 def destroy
    #flash[:success] = "Connector_Project #{@connector_project.Description} destroyed."
    ConnectorProject.find(params[:id]).destroy
    #flash[:success] = "Connector_Project #{@connector_project.Description} destroyed."
    @connector_project = ConnectorProject.all
    redirect_to connector_projects_path
 end
end
