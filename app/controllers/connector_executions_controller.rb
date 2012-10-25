class ConnectorExecutionsController < ApplicationController

 def execute
	cp = ConnectorProject.find(params[:format])
	a = {:consumer_key => cp.consumer_key, :consumer_secret => cp.consumer_secret, :access_username => cp.access_username, :access_password => cp.access_password, :provider => cp.provider, :category => cp.category, :description => cp.description, :user_email => cp.user_email, :org_name => cp.org_name}
	
	@ca = cp.connector_actions.first
    b = {:biz_function => @ca.biz_function, :alias => @ca.alias, :email => @ca.email, :charset_encoding => @ca.charset_encoding, :language => @ca.language, :last_name => @ca.last_name, :locale => @ca.locale, :profile => @ca.profile, :time_zone => @ca.time_zone }
	
	@co = cp.connector_outputs.first
    c = {:type => @co.type, :location => @co.location }

	d = {:access => a, :biz_function => b, :output => c }
  hash_all = d.to_json
  logger.debug "Full JSON #{hash_all}"

	
	#@connector_project = ConnectorProject.find(params[:id])
       cp.connector_executions.each do |ce|
    	ce.update_attribute(:result, hash_all)
       end	
	if cp.save
      flash[:success] = "Connector Execution Result Created with the description #{cp.description}"
      redirect_to connector_projects_path
        end
 
 end

 def show
   #@connector_project = ConnectorProject.all
   #@connector_project = ConnectorProject.find(params[:id])
   # @connector_action = @connector_project.connector_actions.first
   #@connector_execution = ConnectorExecution.all

   @connector_project = ConnectorProject.find(params[:id])
    @connector_execution = @connector_project.connector_executions.first
 end

end
