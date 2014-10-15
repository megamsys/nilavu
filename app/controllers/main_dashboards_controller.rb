class MainDashboardsController < ApplicationController
  respond_to :html
  def index
    if current_user
      @user_id = current_user.id
      @assemblies = ListAssemblies.perform(force_api[:email],force_api[:api_key])
      @assemblies.each do |asm|
      if asm.class == Megam::Error
        else
        puts "============>    output <============"
        puts asm
        puts "============>    output <============"

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
