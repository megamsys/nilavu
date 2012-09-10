class CloudIdentitiesController < ApplicationController

def index
end

def new
	current_user.organization.build_cloud_identity
	@embeddedclient = EmbeddedClient.new
	mc = @embeddedclient.client
	logger.debug "rpc-client #{mc}"
end

def create
	     @cloud_identity = current_user.organization.build_cloud_identity(params[:cloud_identity]) || CloudIdentity.new(params[:cloud_identity])
		
	if @cloud_identity.save
		flash[:success] = "Cloud Identity Created with #{current_user.organization.account_name}"
		redirect_to customizations_show_url
		
	end
end

def show
	 @user = User.find(params[:id])
	 if !@user.organization
          flash[:error] = "Pleae Create Organization Details first"
		redirect_to edit_user_path(current_user)
         end
end

def update
	@cloud_identity=CloudIdentity.find(params[:id])
	if @cloud_identity.update_attributes(params[:cloud_identity])
     		 flash[:success] = "Cloud_identity #{current_user.organization.account_name} updated"
                 redirect_to customizations_show_url
	end
end


def destroy
	
    CloudIdentity.find(params[:id]).destroy
    flash[:success] = "Cloud_identity #{current_user.organization.account_name} destroyed."
    redirect_to customizations_show_url
  end
end
