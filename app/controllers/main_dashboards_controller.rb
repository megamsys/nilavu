class MainDashboardsController < ApplicationController
  respond_to :html
  def index
    if current_user
      @user_id = current_user.id
      @assemblies = ListAssemblies.perform(force_api[:email],force_api[:api_key])

      if @assemblies.class == Megam::Error
        else
        puts "============>    output <============"
        @assemblies.to_yaml
        puts "============>    output <============"

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
