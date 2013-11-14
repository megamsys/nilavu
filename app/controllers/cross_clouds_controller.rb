class CrossCloudsController < ApplicationController
  respond_to :html, :js
  add_breadcrumb "Dashboard", :dashboards_path
  def index
    add_breadcrumb "Cross CLouds", cross_clouds_path
    cross_cloud_options = { :email => current_user.email, :api_key => current_user.api_token }
    @cross_clouds = ListPredefClouds.perform(cross_cloud_options)
    if @cross_clouds.class == Megam::Error
      redirect_to dashboards_path, :gflash => { :warning => { :value => "Oops! sorry, #{@cross_clouds.some_msg[:msg]}", :sticky => false, :nodom_wrap => true } }
    end
    puts "============================> @CROSS CLOUD INDEX <==================================="
    puts @cross_clouds.inspect
  end

  def new
    add_breadcrumb "Cross CLouds", cross_clouds_path
    add_breadcrumb "New Cross CLoud", new_cross_cloud_path
    logger.debug "GOOGLE oauth token ============> "
    puts request.env['omniauth.auth']
  end

  def create
    logger.debug "CROSS CLOUD CREATE PARAMS ============> "
    logger.debug "#{params}"
    options = { :email => current_user.email, :api_key => current_user.api_token, :name => params[:name], :spec => { :type_name => params[:provider], :groups => params[:group], :image => params[:image], :flavor => params[:flavour] }, :access => { :ssh_key => params[:ssh_key], :identity_file => params[:ssh_file], :ssh_user => params[:ssh_user] }  }
    res_body = CreatePredefClouds.perform(options)
    redirect_to cross_clouds_path, :gflash => { :warning => { :value => "CROSS  CLOUD CREATION DONE ", :sticky => false, :nodom_wrap => true } }
  end

  

  def show
    cross_cloud_options = { :email => current_user.email, :api_key => current_user.api_token }
    @cross_clouds = ListPredefClouds.perform(cross_cloud_options)
    @cross_cloud = @cross_clouds.lookup(params[:id])
  end
end