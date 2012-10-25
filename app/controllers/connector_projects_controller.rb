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
    @connector_project = ConnectorProject.all
   end

  def new
    @connector_project = ConnectorProject.build
    @products = Product.all
    @apps_item = current_user.organization.cloud_app.apps_items
  end

  def create
	logger.debug"Param = #{params}"
    @connector_project = ConnectorProject.create(params[:connector_project])
    @connector_project.connector_actions.create(params[:connector_actions])
    @connector_project.connector_outputs.create(params[:connector_outputs])

    if @connector_project.save
      flash[:success] = "Connector project Created with the description #{@connector_project.description}"
      redirect_to connector_projects_path
    end
  end

  def connector_json
    
   @cp = ConnectorProject.all
   @cp.each do |cp|
   a = {:consumer_key => cp.consumer_key, :consumer_secret => cp.consumer_secret, :access_username => cp.access_username, :access_password => cp.access_password, :provider => cp.provider, :category => cp.category, :description => cp.description, :user_email => cp.user_email, :org_name => cp.org_name}
   hash1 = a.to_json 
   #a=@connector_project.to_json(:except => [ :id, :created_at, :updated_at, :connector_outputs_ids, :connector_actions_ids ])
   logger.debug "JSON CP #{hash1}"
   end

   @cp.each do |ca|
    @ca = ca.connector_actions.first
    b = {:biz_function => @ca.biz_function, :alias => @ca.alias, :email => @ca.email, :charset_encoding => @ca.charset_encoding, :language => @ca.language, :last_name => @ca.last_name, :locale => @ca.locale, :profile => @ca.profile, :time_zone => @ca.time_zone }
    hash2 = b.to_json
    #b=@connector_action.to_json
    logger.debug "JSON CA #{hash2}"
   end

   @cp.each do |co|
    @co = co.connector_outputs.first
    c = {:type => @co.type, :location => @co.location }
    hash3 = c.to_json
    #c=@connector_output.to_json(:only => [ :type, :location ])
     #c=@connector_output.to_json(
    logger.debug "JSON CO #{hash3}"
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
    @connector_project.connector_actions.each do |ca|
    	ca.update_attributes(params[:connector_actions])
    end
    @connector_project.connector_outputs.each do |co|
    	co.update_attributes(params[:connector_outputs])
    end

    if @connector_project.update_attributes(params[:connector_project])
      flash[:success] = "Connector_Project #{@connector_project.description} updated"
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
