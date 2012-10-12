class ConnectorActionsController < ApplicationController
  def new

  end

  def create
logger.debug "Connector Project = #{@connector_project.inspect}"
logger.debug "Connector Project = #{@connector_project.to_yaml}"
logger.debug "Params #{params}"
	#@connector_project = ConnectorProject.find(params[:id])
	#@connector_project = ConnectorProject.all
logger.debug "Connector Project = #{@connector_project.to_yaml}"
	logger.debug "CA_CP = #{@connector_project}"
    @connector_action = @connector_project.connector_actions.create(params[:connector_action])
    #@connector_action = @connector_project.ConnectorAction.create(params[:connector_action])
     #@connector_action = ConnectorProject.ConnectorAction.create(params[:connector_action])
    #@connector_action = ConnectorProject.connector_actions.create(params[:connector_action])
    if @connector_action.save
      redirect_to connector_projects_path
    end
  end
end
