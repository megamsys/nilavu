class MainDashboardsController < ApplicationController
  respond_to :html
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

end
