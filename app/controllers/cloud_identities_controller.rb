class CloudIdentitiesController < ApplicationController

def index
end

def new
	current_user.organization.build_cloud_identity
end

def create
	     @cloud_identity = current_user.organization.build_cloud_identity(params[:cloud_identity]) || CloudIdentity.new(params[:cloud_identity])
		
	if @cloud_identity.save
		redirect_to customizations_show_url
		flash[:success] = "Cloud_identity Created"
	end
end

def show
	 @user = User.find(params[:id])

end

def update
	@cloud_identity=CloudIdentity.find(params[:id])
	if @cloud_identity.update_attributes(params[:cloud_identity])
     		 flash[:success] = "Cloud_identity updated"
	end
end


def destroy
	
    CloudIdentity.find(params[:id]).destroy
    flash[:success] = "Cloud_identity destroyed."
    redirect_to customizations_show_url
  end
end
