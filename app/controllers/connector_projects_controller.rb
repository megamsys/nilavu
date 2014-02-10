class ConnectorProjectsController < ApplicationController
  respond_to :html, :js  
  def index
    breadcrumbs.add "projects", :root_path
    if !current_user.organization
      flash[:error] = "Please Create Organization Details first"
      redirect_to edit_user_path(current_user)
    #elsif !current_user.organization.apps_items
    # flash[:error] = "Please Add any cloud Applications"
    # redirect_to new_apps_item_path
    end
  # @connector_project = ConnectorProject.all
  end

  def new
    breadcrumbs.add "projects", :root_path
    @products = Product.all
  end

  def import
    @products = Product.all
    logger.debug"Param = #{params}"
    @api_name = params[:api_name]
    @url = params[:url]
    @app_url = params[:app_url]
    respond_to do |format|
      format.js {
        respond_with(@api_name, @url, @app_url, :layout => !request.xhr? )
      }
    end
  end

  def singularize
    Inflector.singularize(self)
  end

  def resource
    @products = Product.all
    logger.debug"Param = #{params}"
    @rest_api_name = Inflector.singularize(params[:restapi_url])
    case params[:url]
    when "http://www.salesforce.com"
      @app_name = "salesforcecrm"
    when "http://www.google.com"
      @app_name = "googleapps"
    when "http://xero.com"
      @app_name = "xero"
    when "http://sugarcrm.com"
      @app_name = "sugarcrm"
    when "http://www.zoho.com"
      @app_name = "zohocrm"
    when "http://www.box.com"
      @app_name = "box"
    else
    logger.debug "You gave me #{params[:url]} -- I have no idea what to do with that."
    end
    response = Net::HTTP.get_response(URI("https://raw.github.com/rajthilakmca/deccanplato/master/src/test/resources/"+@app_name+"/"+@rest_api_name+"_create.json"))
    @json = response.body
    respond_to do |format|
      format.js {
        respond_with(@json, :layout => !request.xhr? )
      }
    end
  end

  def deccanplato
    logger.debug"Param-------- = #{params}"
    @json = params[:json]
    options = { :json => @json}
    res_body = Crm.perform(options) 
    #@result_class = res_body.class   
    if res_body.class == Megam::Error
      @result = "Please contact #{ActionController::Base.helpers.link_to 'support !.', "http://support.megam.co/"}."
      @result_class = "Megam_Error"
    else
      @result_class = "Deccanplato_result"
      @result = JSON.parse(res_body)["responseMap"]["salesforcecrm"]["output"]
    end

    respond_to do |format|
      format.js {
        respond_with(@result, @result_class, :layout => !request.xhr? )
      }
    end
  end

  def create
    logger.debug"Param-------- = #{params}"
    @connector_project = ConnectorProject.create(params[:connector_project])
    @connector_project.connector_actions.create(params[:connector_actions])
    @connector_project.connector_outputs.create(params[:connector_outputs])
    @connector_project.connector_executions.create(:access_email => current_user.email, :access_org_id => current_user.organization.id, :access_account_name => current_user.organization.account_name, :api_token => current_user.organization.api_token)
    if @connector_project.save
      flash[:success] = "Connector project Created with the description #{@connector_project.description}"
      redirect_to connector_projects_path
    end
  end

  def upload    
    @connector_project = ConnectorProject.build
  end

  def show
    @connector_project = ConnectorProject.find(params[:id])
    @connector_action = @connector_project.connector_actions.first
    @connector_output = @connector_project.connector_outputs.first
    @products = Product.all
    @apps_item = current_user.organization.apps_items
  end

  def export
    a = "Hello"
    doc = "project.json"
    File.open(doc, "w"){ |f| f << a}
    send_file(doc, :type => 'text; charset=utf-8')

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

    @cp.connector_executions.each do |ce|
      ce.delete()
    end

    @cp.delete()
    respond_with(@cp, :layout => !request.xhr? )

  end
end
