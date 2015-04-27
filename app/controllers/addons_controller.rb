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
class AddonsController < ApplicationController

  respond_to :html, :js
    include MainDashboardsHelper
 def index
    if user_in_cookie?
      @user_id = current_user.email

      @assemblies = ListAssemblies.perform(force_api[:email],force_api[:api_key])
      @service_counter = 0
      @app_counter = 0
      if @assemblies != nil
        @assemblies.each do |asm|
          if asm.class != Megam::Error
            asm.assemblies.each do |assembly|
              if assembly != nil
                if assembly[0].class != Megam::Error
                  #@app_counter = assembly[0].components.count + @app_counter
                  assembly[0].components.each do |com|
                    if com != nil
                      com.each do |c|
                        com_type = c.tosca_type.split(".")
                        ctype = get_type(com_type[2])
                         if ctype == "ADDON"
                           @service_counter = @service_counter + 1
                        else
                                @app_counter = @app_counter + 1
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
      redirect_to signin_path
    end
  end



  def new
    logger.debug "Cloud Store new  ==> "
  end


  def create
    logger.debug "Create Cloud store Params ==> "
    logger.debug "#{params}"
  end

  def show
    wparams = {:node => "#{params[:name]}" }
    #look at storing in a local session, as we are redoing it.
    # The node json is getting heavy as well
    @node = FindNodeByName.perform(wparams,force_api[:email],force_api[:api_key])
    logger.debug "--> CloudBooks:show, found node #{wparams[:node]}"
    if @node.class == Megam::Error
      @res_msg="We went into nirvana, finding node #{wparams[:node]}. Open up a support ticket. We'll investigate its disappearence #{ActionController::Base.helpers.link_to 'support !.', "http://support.megam.co/"}."
      respond_to do |format|
        format.js {
          respond_with(@res_msg, :layout => !request.xhr? )
        }
      end
    else
      @requests = GetRequestsByNode.perform(wparams,force_api[:email], force_api[:api_key])  #no error checking for GetRequestsByNode ?
      @book_requests =  GetDefnRequestsByNode.send(params[:book_type].downcase.to_sym, wparams,force_api[:email], force_api[:api_key])
      if @book_requests.class == Megam::Error
        @book_requests={"results" => {"req_type" => "", "create_at" => "", "lc_apply" => "", "lc_additional" => "", "lc_when" => ""}}
      end
      @cloud_book = @node.lookup("#{params[:name]}")
      respond_to do |format|
        format.js {
          respond_with(@cloud_book, @requests, @book_requests, :layout => !request.xhr? )
        }
      end
    end
  end


end
