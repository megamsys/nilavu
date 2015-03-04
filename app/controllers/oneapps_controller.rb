class OneappsController < ApplicationController

  respond_to :html, :js
  include Packable
  include OneappsHelper
  include MainDashboardsHelper
  include MarketplaceHelper
  def show
    #@app = Appscollection(params[:app_name])
    #get the selected app
  end

  def overview
    if current_user_verify
      appid = params["appkey"]
      @assembly=GetAssembly.perform(appid,force_api[:email],force_api[:api_key])
    else
      redirect_to signin_path
    end
  end

  def logs
    if current_user_verify
      @com_books = []
      @socketURL = Rails.configuration.socket_url
      appid = params["appkey"]
      assembly=GetAssembly.perform(appid,force_api[:email],force_api[:api_key])
      # if assembly.class != Megam::Error
      @appname = assembly.name + "." + assembly.components[0][0].inputs[:domain]
      # else
      #  @appname = nil
      #end
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

  def bind_service_list
    if current_user_verify
      @bindapp = params[:bindapp]
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
                        if c.related_components == ""
                          com_type = c.tosca_type.split(".")
                          ctype = get_type(com_type[2])
                          if ctype == "SERVICE"
                            @service << {"name" => assembly[0].name + "." + c.inputs[:domain] + "/" + c.name, "aid" => assembly[0].id, "cid" => c.id }
                          # @service << assembly[0].name + "." + c.inputs[:domain] + "/" + c.name
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
      respond_to do |format|
        format.js {
          respond_with(@bindapp, @service, :layout => !request.xhr? )
        }
      end
    else
      redirect_to signin_path
    end
  end

  def bindService
    updatebinds(params[:bindapp], params[:bindservice])
    updatebinds(params[:bindservice], params[:bindapp])

  end

  def updatebinds(data, bindData)
    if current_user_verify
      if data != ""
        bindedAPP = data.split(":")
        get_assembly = GetAssemblyWithoutComponentCollection.perform(bindedAPP[0], force_api[:email], force_api[:api_key])
        if get_assembly.class == Megam::Error
          @res_msg = nil
          @err_msg="Please contact #{ActionController::Base.helpers.link_to 'support !.', "http://support.megam.co/"}."
          respond_to do |format|
            format.js {
              respond_with(@res_msg, @err_msg, :layout => !request.xhr? )
            }
          end
        else
          get_component = GetComponent.perform(bindedAPP[1], force_api[:email], force_api[:api_key])
          if get_component.class == Megam::Error
            @res_msg = nil
            @err_msg="Please contact #{ActionController::Base.helpers.link_to 'support !.', "http://support.megam.co/"}."
            respond_to do |format|
              format.js {
                respond_with(@res_msg, @err_msg, :layout => !request.xhr? )
              }
            end
          else
            bindedData = bindData.split(":")
            relatedcomponent = bindedData[2]
            update_component_json = UpdateComponentJson.perform(get_component, relatedcomponent)
            update_component = UpdateComponent.perform(update_component_json, force_api[:email], force_api[:api_key])
            if update_component.class == Megam::Error
              @res_msg = nil
              @err_msg="Please contact #{ActionController::Base.helpers.link_to 'support !.', "http://support.megam.co/"}."
              respond_to do |format|
                format.js {
                  respond_with(@res_msg, @err_msg, :layout => !request.xhr? )
                }
              end
            else
              update_json = UpdateAssemblyJson.perform(get_assembly, get_component)
              update_assembly = UpdateAssembly.perform(update_json, force_api[:email], force_api[:api_key])
              if update_assembly.class == Megam::Error
                @res_msg = nil
                @err_msg="Please contact #{ActionController::Base.helpers.link_to 'support !.', "http://support.megam.co/"}."
                respond_to do |format|
                  format.js {
                    respond_with(@res_msg, @err_msg, :layout => !request.xhr? )
                  }
                end
              else
                @err_msg = nil
              end
            end
          end
        end
      end
    else
      redirect_to signin_path
    end
  end

  def lcapp
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
    if current_user_verify
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
    else
      redirect_to signin_path
    end
  end
end
