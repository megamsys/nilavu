class CloudIdentitiesController < ApplicationController
def index
end

def create
	params = {"cloud_identity" => {"url" => "www.google.com"}}
	@cloud_identity = CloudIdentity.new(params[:cloud_identity])
	if @cloud_identity.save
		redirect_to customizations_show_url
	end
end

def show
  end
end
