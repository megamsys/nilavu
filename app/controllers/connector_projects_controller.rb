class ConnectorProjectsController < ApplicationController
  respond_to :html, :js
  
  
  def index
    if !current_user.organization
      flash[:error] = "Please Create Organization Details first"
      redirect_to edit_user_path(current_user)
    elsif !current_user.organization.cloud_app
      flash[:error] = "Please Add any cloud Applications"
      redirect_to cloud_app_path(current_user.id)
    end
    #if !ConnectorProject.nil?
    @connector_project = ConnectorProject.all
  #end
  end

  def new
    @connector_project = ConnectorProject.build
    #@connector_project = ConnectorProject.create
    #@connector_action.build_connector_actions
    #@connector_action = @connector_project.connector_actions.create(:biz_function => "users#create")
    #@connector_output = @connector_project.connector_outputs.create
    @products = Product.all
    @apps_item = current_user.organization.cloud_app.apps_items
  end

  def create
    @connector_project = ConnectorProject.create(params[:connector_project])
    @connector_project.connector_actions.create(params[:connector_actions])
    @connector_project.connector_outputs.create(params[:connector_output])

    if @connector_project.save
      flash[:success] = "Connector project Created with the description #{@connector_project.Description}"
      redirect_to connector_projects_path
    end
  end

  def show
    @connector_project = ConnectorProject.find(params[:id])
    @connector_action = @connector_project.connector_actions.first
    @connector_output = @connector_project.connector_outputs.first

    @products = Product.all
    @apps_item = current_user.organization.cloud_app.apps_items
  end

  def update
    @connector_project = ConnectorProject.find(params[:id])
    @connector_action = @connector_project.update_attributes(params[:connector_actions])
    @connector_output  = @connector_project.update_attributes(params[:connector_output])

    if @connector_project.update_attributes(params[:connector_project])
      flash[:success] = "Connector_Project #{@connector_project.Description} updated"
      redirect_to connector_projects_path
    end
  end

  def destroy
    @cp =  ConnectorProject.find(params[:id])

    @cp.connector_actions.each do |ca|
      ca.delete()
    end

    @cp.connector_outputs.each do |co|
      co.delete()
    end

    @cp.delete()  
    respond_with(@cp, :layout => !request.xhr? )
 
  end
end
