class MainDashboardsController < ApplicationController
  respond_to :html, :js
  include MainDashboardsHelper
  def index
    if current_user
      @user_id = current_user.id

      @assemblies = ListAssemblies.perform(force_api[:email],force_api[:api_key])
      @service_counter = 0
      @app_counter = 0
      puts @assemblies.class
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

  def visualCallback
    if current_user
      redirect_to main_dashboards_path, :gflash => { :error => { :value => "Invalid username and password combination, Please Enter your correct megam email", :sticky => false, :nodom_wrap => true } }
    else
      redirect_to signin_path, :gflash => { :error => { :value => "Invalid username and password combination, Please Enter your correct megam email", :sticky => false, :nodom_wrap => true } }
    end
  end

  def show
    redirect_to main_dashboards_path
  end

  def startapp
    puts params
    @id = params[:id]
    @name = params[:name]
    respond_to do |format|
      format.js {
        respond_with(@id, @name, :layout => !request.xhr? )
      }
    end
  end
  
  def stopapp
    puts params
    @id = params[:id]
    @name = params[:name]
    respond_to do |format|
      format.js {
        respond_with(@id, @name, :layout => !request.xhr? )
      }
    end
  end
  
  def restartapp
    puts params
    @id = params[:id]
    @name = params[:name]
    respond_to do |format|
      format.js {
        respond_with(@id, @name, :layout => !request.xhr? )
      }
    end
  end

  def app_request
    logger.debug "--> Apps:Build_request, #{params}"
    options = {:app_id => "#{params[:app_id]}", :app_name => "#{params[:app_name]}", :action => "#{params[:command]}"}
    defnd_result =  CreateAppRequests.perform(options, force_api[:email], force_api[:api_key])
         
     if defnd_result.class == Megam::Error
      @err_msg="Please contact #{ActionController::Base.helpers.link_to 'support !.', "http://support.megam.co/"}."
      respond_to do |format|
        format.js {
          respond_with(@err_msg, :layout => !request.xhr? )
        }
      end
    end
  
   
  end

end
