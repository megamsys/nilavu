class OneserviceController < ApplicationController

  respond_to :html, :js
  include Packable
  include OneappsHelper
  def show

  end

  def overview
    serviceid = params["servicekey"]
    @assembly=GetAssembly.perform(serviceid,force_api[:email],force_api[:api_key])
  end

  def metrics
    serviceid = params["servicekey"]
    assembly=GetAssembly.perform(serviceid,force_api[:email],force_api[:api_key])
    if assembly.class != Megam::Error
      @appname = assembly.name + "." + assembly.components[0][0].inputs[:domain]
    else
      @appname = nil
    end
  end
  
  def logs
    @com_books = []
    appid = params["servicekey"]
    assembly=GetAssembly.perform(appid,force_api[:email],force_api[:api_key])
    if assembly.class != Megam::Error
      @appname = assembly.name + "." + assembly.components[0][0].inputs[:domain]
    else
      @appname = nil
    end
    assembly.components.each do |com|
      if com != nil
        com.each do |c|
            @com_books << c.name
        end
      end
    end
  end

  def runtime
    serviceid = params["servicekey"]
  end

  def services
    serviceid = params["servicekey"]
  end

  def lcservice
    puts params
    @id = params[:id]
    @name = params[:name]
    @command = params[:command]
    respond_to do |format|
      format.js {
        respond_with(@id, @name, @command, :layout => !request.xhr? )
      }
    end
  end

  def service_request
    logger.debug "--> service:Build_request, #{params}"
    options = {:app_id => "#{params[:service_id]}", :app_name => "#{params[:service_name]}", :action => "#{params[:command]}"}
    defnd_result =  CreateAppRequests.perform(options, force_api[:email], force_api[:api_key])
    if params[:command] == "stop"
      @res_msg = "Service #{params[:command]}ped successfully"
    else
      @res_msg = "Service #{params[:command]}ed successfully"
    end
    @err_msg = nil
    if defnd_result.class == Megam::Error
      @res_msg = nil
      @err_msg= ActionController::Base.helpers.link_to 'Contact support ', "http://support.megam.co/"
      respond_to do |format|
        format.js {
          respond_with(@res_msg, @err_msg, :layout => !request.xhr? )
        }
      end
    end
  end

end
