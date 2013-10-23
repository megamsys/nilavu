class PredefCloudsController < ApplicationController

  respond_to :html, :js
  add_breadcrumb "Dashboard", :dashboards_path
  def index
    add_breadcrumb "Cross CLouds", predef_clouds_path
    predef_cloud_options = { :email => current_user.email, :api_key => current_user.api_token }
    @predef_clouds = ListPredefClouds.perform(predef_cloud_options)
      if @predef_clouds.class == Megam::Error
        redirect_to dashboards_path, :gflash => { :warning => { :value => "Oops! sorry, #{@predef_clouds.some_msg[:msg]}", :sticky => false, :nodom_wrap => true } }
      end
    puts "============================> @PREDEF CLOUD INDEX <==================================="
    puts @predef_clouds.inspect
  end

  def new
    add_breadcrumb "Cross CLouds", predef_clouds_path
    add_breadcrumb "New Cross CLoud", new_predef_cloud_path
  end

  def new_db
	logger.debug "New DB  ==> "
    add_breadcrumb "CLoud DB", predef_clouds_path
    add_breadcrumb "New Cloud DB", new_predef_cloud_path
  end

  def new_db_init
	logger.debug "New DB init Params ==> "
	logger.debug "#{params}"
    add_breadcrumb "CLoud DB", predef_clouds_path
    add_breadcrumb "New Cloud DB", new_predef_cloud_path
	@db_model = params[:db_model]
	@dbms = params[:dbms]
  end

  def create_db
	logger.debug "Create DB Params ==> "
	logger.debug "#{params}"
  end

  def create
	logger.debug "PREDEF CLOUD CREATE PARAMS ============> "
	logger.debug "#{params}"
  end

  def show
    predef_cloud_options = { :email => current_user.email, :api_key => current_user.api_token }
    @predef_clouds = ListPredefClouds.perform(predef_cloud_options)
    @predef_cloud = @predef_clouds.lookup(params[:id])
  end
end
