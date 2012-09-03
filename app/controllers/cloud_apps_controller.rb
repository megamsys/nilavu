class CloudAppsController < ApplicationController
  
  def new
	
	current_user.organization.build_cloud_app
  end
  
  def create
	
	
end

  def show
	 @user = User.find(params[:id])
        if !@user.organization.cloud_app
	 @cloud_app = current_user.organization.build_cloud_app(params[:cloud_app]) || CloudApp.new(params[:cloud_app])
	   @cloud_app.name = current_user.organization.name	
	 if @cloud_app.save
		redirect_to new_apps_item_path
		flash[:success] = "Cloud_App Created"
	 end
	
	else
		redirect_to new_apps_item_path
	end

	
  end
  
  def update
	@cloud_app = CloudApp.find(params[:id])
	if @cloud_app.update_attributes(params[:cloud_app])
     		 flash[:success] = "Cloud_App updated"
	redirect_to cloud_app_path(current_user)
	end
	
  end
  
  def delete
  end

end
