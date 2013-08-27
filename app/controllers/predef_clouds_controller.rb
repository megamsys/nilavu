class PredefCloudsController < ApplicationController

  respond_to :html, :js
  add_breadcrumb "Dashboard", :dashboards_path

  def index
      add_breadcrumb "Predef CLouds", predef_clouds_path
    predef_cloud_options = { :email => current_user.email, :api_key => current_user.api_token }
   @predef_clouds = ListPredefClouds.perform(predef_cloud_options)
	puts "============================> @PREDEF CLOUD INDEX <==================================="
	puts @predef_clouds.inspect
  end

  def new
      add_breadcrumb "Predef CLouds", predef_clouds_path
      add_breadcrumb "New Predef CLoud", new_predef_cloud_path
  end

  def create
	puts "PREDEF CLOUD CREATE PARAMS ============> "
	puts params
  end

  def show
    predef_cloud_options = { :email => current_user.email, :api_key => current_user.api_token }
   @predef_clouds = ListPredefClouds.perform(predef_cloud_options)
	@predef_cloud = @predef_clouds.lookup(params[:id])

  end
end
