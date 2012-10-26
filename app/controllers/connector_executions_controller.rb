class ConnectorExecutionsController < ApplicationController

 def execute
	cp = ConnectorProject.find(params[:format])
	a = {:access => {:project_id => cp.id, :api_token => current_user.organization.api_token, :access_email => current_user.email, :access_org_id => current_user.organization.id, :access_account_name => current_user.organization.account_name} }
	
	@ca = cp.connector_actions.first
    b = {:access => {:consumer_key => cp.consumer_key, :consumer_secret => cp.consumer_secret, :access_username => cp.access_username, :access_password => cp.access_password, :provider => cp.provider, :category => cp.category, :description => cp.description, :user_email => cp.user_email, :org_name => cp.org_name},
:business_activity => {:biz_function => @ca.biz_function, :alias => @ca.alias, :email => @ca.email, 
:charset_encoding => @ca.charset_encoding, :language => @ca.language, :last_name => @ca.last_name, :locale => @ca.locale, :profile => @ca.profile, :time_zone => @ca.time_zone } } 
	
	@co = cp.connector_outputs.first
    c = {:output => {:type => @co.type, :location => @co.location } }

	d = {:system => a, :provider => b, :execution => c }
  hash_all = d.to_json
  logger.debug "Full JSON #{hash_all}"

	
	#@connector_project = ConnectorProject.find(params[:id])
       cp.connector_executions.each do |ce|
    	ce.update_attribute(:result, hash_all)
       end	
	if cp.save
      		flash[:success] = "Connector Execution Result Created with the description #{cp.description}"
      		#redirect_to connector_projects_path
		redirect_to connector_execution_path(cp.id)
        end
 
 end

  def export
    @connector_project = ConnectorProject.find(params[:format])
    @connector_execution = @connector_project.connector_executions.first
    doc = "project.json"
    File.open(doc, "w"){ |f| f << @connector_execution.result }
    send_file(doc, :type => 'text; charset=utf-8')
  
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
