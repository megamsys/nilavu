class MainDashboardsController < ApplicationController
  respond_to :html
  def index
    if current_user
      @user_id = current_user.id
      if @assemblies != nil
        @assemblies = ListAssemblies.perform(force_api[:email],force_api[:api_key])
        @assemblies.each do |asm|
          asm.assemblies.each do |assembly|
            if assembly != nil
              if assembly[0].class != Megam::Error
                assembly[0].components.each do |com|
                  puts com.class
                  if com != nil
                    com.each do |c|
                      puts c.name
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
