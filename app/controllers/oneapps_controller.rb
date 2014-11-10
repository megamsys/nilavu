class OneappsController < ApplicationController

  respond_to :html, :js
  include Packable
  include OneappsHelper
  def show
    #@app = Appscollection(params[:app_name])
    #get the selected app
  end

  def overview
    appid = params["appkey"]
    @assembly=GetAssembly.perform(appid,force_api[:email],force_api[:api_key])
  #@app = Appscollection(params[:app_name])
  #get the selected app
  end

  def logs
    appid = params["appkey"]
    assembly=GetAssembly.perform(appid,force_api[:email],force_api[:api_key])
    if assembly.class != Megam::Error
      @appname = assembly.name + "." + assembly.components[0][0].inputs[:domain]
    else
      @appname = nil
    end

  end

  def runtime
    appid = params["appkey"]
  #@app = Appscollection(params[:app_name])
  #get the selected app
  end

  def services
    appid = params["appkey"]
  #@app = Appscollection(params[:app_name])
  #get the selected app
  end

  def bind_service_list
    @service = []
    @assemblies = ListAssemblies.perform(force_api[:email],force_api[:api_key])
    @service_counter = 0
    @app_counter = 0
    if @assemblies != nil
      @assemblies.each do |asm|
        if asm.class != Megam:: Error
          asm.assemblies.each do |assembly|
            if assembly != nil
              if assembly[0].class != Megam::Error

                assembly[0].components.each do |com|
                  if com != nil
                    com.each do |c|
                      com_type = c.tosca_type.split(".")
                      ctype = get_type(com_type[2])
                      if ctype == "SERVICE"
                        @service << {"name" => assembly[0].name + "." + assembly[0].components[0][0].inputs[:domain] + "/" + com[0].name, "aid" => assembly[0].id, "cid" => assembly[0].components[0][0].id }
                      end
                    end
                  end
                end

              end
            end
          end
        end
      end
    end

  end
  
  def lcapp
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
  
  
    def app_request
    logger.debug "--> Apps:Build_request, #{params}"
    options = {:app_id => "#{params[:app_id]}", :app_name => "#{params[:app_name]}", :action => "#{params[:command]}"}
    defnd_result =  CreateAppRequests.perform(options, force_api[:email], force_api[:api_key])
    if params[:command] == "stop"
      @res_msg = "App #{params[:command]}ped successfully"
    else
      @res_msg = "App #{params[:command]}ed successfully"
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
