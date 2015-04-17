##
## Copyright [2013-2015] [Megam Systems]
##
## Licensed under the Apache License, Version 2.0 (the "License");
## you may not use this file except in compliance with the License.
## You may obtain a copy of the License at
##
## http://www.apache.org/licenses/LICENSE-2.0
##
## Unless required by applicable law or agreed to in writing, software
## distributed under the License is distributed on an "AS IS" BASIS,
## WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
## See the License for the specific language governing permissions and
## limitations under the License.
##
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
    if user_in_cookie?
      appid = params["appkey"]
      @assembly=GetAssembly.perform(appid,force_api[:email],force_api[:api_key])
    else
      redirect_to signin_path
    end
  end

  def logs
    if user_in_cookie?
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
    if user_in_cookie?
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
    if user_in_cookie?
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

 app_update  =  updatebinds(params[:bindapp], params[:bindservice])
  service_update = updatebinds(params[:bindservice], params[:bindapp])
  if app_update == true && service_update == true
   respond_to do |format|
              format.js {
                respond_with( :layout => !request.xhr? )
              }
            end
  else
  respond_to do |format|
              format.js {
                respond_with( :layout => !request.xhr? )
              }
            end
   end

  end

  def updatebinds(data, bindData)

    if user_in_cookie?
      if data != ""
        bindedAPP = data.split(":")
        get_assembly = GetAssemblyWithoutComponentCollection.perform(bindedAPP[0], force_api[:email], force_api[:api_key])
        if get_assembly.class == Megam::Error
          @res_msg = nil
          @err_msg="Please contact #{ActionController::Base.helpers.link_to 'support !.', "http://support.megam.co/"}."
          #respond_to do |format|
           # format.js {
            #  respond_with(@res_msg, @err_msg, :layout => !request.xhr? )
            #}
          #end
          return false
        else
          get_component = GetComponent.perform(bindedAPP[1], force_api[:email], force_api[:api_key])
          if get_component.class == Megam::Error
            @res_msg = nil
            @err_msg="Please contact #{ActionController::Base.helpers.link_to 'support !.', "http://support.megam.co/"}."
            #respond_to do |format|
            #  format.js {
            #    respond_with(@res_msg, @err_msg, :layout => !request.xhr? )
            #  }
            #end
            return false
          else
            bindedData = bindData.split(":")
            relatedcomponent = bindedData[2]
            update_component_json = UpdateComponentJson.perform(get_component, relatedcomponent)

            update_component = UpdateComponent.perform(update_component_json, force_api[:email], force_api[:api_key])
            if update_component.class == Megam::Error
              @res_msg = nil
              @err_msg="Please contact #{ActionController::Base.helpers.link_to 'support !.', "http://support.megam.co/"}."
              #respond_to do |format|
              #  format.js {
              #    respond_with(@res_msg, @err_msg, :layout => !request.xhr? )
              #  }
              #end
              return false
            else
           bindedData = bindData.split(":")

            get_bindAssembly = GetAssemblyWithoutComponentCollection.perform(bindedData[0], force_api[:email], force_api[:api_key])
            get_bindComponent = GetComponent.perform(bindedData[1], force_api[:email], force_api[:api_key])

              update_json = UpdateAssemblyJson.perform(get_assembly, get_component)
              update_bind_json = UpdateSeperateAssemblyJson.perform(get_assembly, get_bindAssembly, get_bindComponent)
              update_assembly = UpdateAssembly.perform(update_json, force_api[:email], force_api[:api_key])
              update_bindassembly = UpdateAssembly.perform(update_bind_json, force_api[:email], force_api[:api_key])
              if update_assembly.class == Megam::Error
                @res_msg = nil
                @err_msg="Please contact #{ActionController::Base.helpers.link_to 'support !.', "http://support.megam.co/"}."
                #respond_to do |format|
                #  format.js {
                #    respond_with(@res_msg, @err_msg, :layout => !request.xhr? )
                #  }
                #end
                return false
              else
                #@err_msg = nil
                return true
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
    if user_in_cookie?
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
