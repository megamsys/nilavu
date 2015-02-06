class OneaddonsController < ApplicationController

  respond_to :html, :js
  include Packable
  include OneappsHelper
  def show
    #@app = Appscollection(params[:app_name])
    #get the selected app
  end

  def overview
    if current_user_verify
      appid = params["appkey"]
      @dockerID = ""
      @assembly=GetAssembly.perform(appid,force_api[:email],force_api[:api_key])
      if @assembly.class != Megam::Error
        @assembly.outputs.each do |output|
          if output["key"] == "container"
            @dockerID = output["value"]
          end
        end
        #@cluster = @assembly.name + "." + @assembly.components[0][0].inputs[:domain]
        @cluster = @assembly.name
        component = GetComponent.perform(@assembly.components[0],force_api[:email],force_api[:api_key])
        @assemblies = ListAssemblies.perform(force_api[:email],force_api[:api_key])
        if @assemblies.class == Megam::Error
          redirect_to main_dashboards_path, :gflash => { :warning => { :value => "API server may be down. Please contact #{ActionController::Base.helpers.link_to 'support !.', "http://support.megam.co/", :target => "_blank"}.", :sticky => false, :nodom_wrap => true } }
        else
          @container_counter = 0
          if @assemblies != nil
            @assemblies.each do |asm|
              if asm.class != Megam:: Error
                asm.assemblies.each do |assembly|
                  if assembly != nil
                    if assembly[0].class != Megam::Error
                      assembly[0].components.each do |com|
                        if com != nil
                          com.each do |c|
                            if c.requirements[:host] == @dockerID
                              @container_counter = @container_counter + 1
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
      else
        redirect_to main_dashboards_path, :gflash => { :warning => { :value => "API server may be down. Please contact #{ActionController::Base.helpers.link_to 'support !.', "http://support.megam.co/", :target => "_blank"}.", :sticky => false, :nodom_wrap => true } }
      end
    else
      redirect_to signin_path
    end
  end

  def metrics
    if current_user_verify
      @com_books = []
      @socketURL = Rails.configuration.socket_url
      appid = params["appkey"]
      assembly=GetAssembly.perform(appid,force_api[:email],force_api[:api_key])
      if assembly.class != Megam::Error
        @appname = assembly.name + "." + assembly.components[0][0].inputs[:domain]
      else
        @appname = nil
      end
      assembly.components.each do |com|
        if com != nil
          com.each do |c|
            com_type = c.tosca_type.split(".")
            @com_books << c.name + "-" + com_type[2]
          end
        end
      end
    else
      redirect_to signin_path
    end
  end

  def runtime
    if current_user_verify
      appid = params["appkey"]
      assembly=GetAssembly.perform(appid,force_api[:email],force_api[:api_key])
      if assembly.class != Megam::Error
        @appname = assembly.name + "." + assembly.components[0][0].inputs[:domain]
      else
        @appname = nil
      end
    else
      redirect_to signin_path
    end
  end

  def services
    appid = params["appkey"]
  end

  def lcaddon
    @id = params[:id]
    @name = params[:name]
    @command = params[:command]
    respond_to do |format|
      format.js {
        respond_with(@id, @name, @command, :layout => !request.xhr? )
      }
    end
  end

  def addon_request
    if current_user_verify
      logger.debug "--> Addons:Build_request, #{params}"
      options = {:app_id => "#{params[:addon_id]}", :app_name => "#{params[:addon_name]}", :action => "#{params[:command]}"}
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
    else
      redirect_to signin_path
    end
  end

end
