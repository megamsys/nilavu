class CloudAppsController < ApplicationController
  
  def new
	#@user = User.find(params[:id])
	current_user.organization.build_cloud_app
  end
  
  def create
	
	
       @cloud_app = current_user.organization.build_cloud_app(params[:cloud_app]) || CloudApp.new(params[:cloud_app])
		
	if @cloud_app.save
		redirect_to customizations_show_url
		flash[:success] = "Cloud_App Created"
	end
end

  def show
	 @user = User.find(params[:id])
  end
  
  def delete
  end

end
