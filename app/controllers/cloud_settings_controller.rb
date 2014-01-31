class CloudSettingsController < ApplicationController
  respond_to :html, :js
  include CrossCloudsHelper
  def new
  end

  def cross_cloud_init
    @cross_clouds_collection = ListPredefClouds.perform(force_api[:email], force_api[:api_key])
    if @cross_clouds_collection.class != Megam::Error
      @cross_clouds = []
      cross_clouds = []
      @cross_clouds_collection.each do |pre_cl|
        cross_clouds << {:name => pre_cl.name, :created_at => pre_cl.created_at.to_time.to_formatted_s(:rfc822)}
      end
      @cross_clouds = cross_clouds.sort_by {|vn| vn[:created_at]}
    end
  end

  def cloud_tools_init
    @cloud_tool_setting_collection = ListCloudToolSettings.perform(force_api[:email], force_api[:api_key])
    if @cloud_tool_setting_collection.class != Megam::Error
      @cloud_tool_settings = []
      cloud_tool_settings = []
      @cloud_tool_setting_collection.each do |pre_cl|
        cloud_tool_settings << {:name => pre_cl.repo_name, :created_at => pre_cl.created_at.to_time.to_formatted_s(:rfc822)}
      end
      @cloud_tool_settings = cloud_tool_settings.sort_by {|vn| vn[:created_at]}
    end
  end

  def index
    breadcrumbs.add "Home", "#"
    breadcrumbs.add "Manage Settings", cloud_settings_path
    cross_cloud_init
    cloud_tools_init
    if @cloud_tool_setting_collection.class == Megam::Error && @cross_clouds_collection.class == Megam::Error
      redirect_to cloud_dashboards_path, :gflash => { :warning => { :value => "Oops! sorry, #{@cloud_tool_setting_collection.some_msg[:msg]}, #{@cross_clouds_collection.some_msg[:msg]}", :sticky => false, :nodom_wrap => true } }
    elsif @cloud_tool_setting_collection.class == Megam::Error
      redirect_to cloud_dashboards_path, :gflash => { :warning => { :value => "Oops! sorry, #{@cloud_tool_setting_collection.some_msg[:msg]}", :sticky => false, :nodom_wrap => true } }
    elsif @cross_clouds_collection.class == Megam::Error
      redirect_to cloud_dashboards_path, :gflash => { :warning => { :value => "Oops! sorry, #{@cross_clouds_collection.some_msg[:msg]}", :sticky => false, :nodom_wrap => true } }
    end
  end

  def show
    @cc_msg = nil
    @cts_msg = nil
    if params[:type] == "cross_cloud"
      @cc_msg = params[:type]
      @cts_msg = nil
      @cross_clouds = ListPredefClouds.perform(force_api[:email], force_api[:api_key])
      @cross_cloud = @cross_clouds.lookup(params[:id])
    else
      @cts_msg = params[:type]
      @cc_msg = nil
      @cloud_tool_settings = ListCloudToolSettings.perform(force_api[:email], force_api[:api_key])
      @cloud_tool_setting = @cloud_tool_settings.lookup(params[:id])
    end
    respond_to do |format|
      format.js {
        respond_with(@cc_msg, @cts_msg, @cross_cloud, @cloud_tool_setting, :layout => !request.xhr? )
      }
    end
  end

   def cloud_tool_setting_new
      breadcrumbs.add "Home", "#"
      breadcrumbs.add "Manage Settings", cloud_settings_path
      breadcrumbs.add "Cloud Provisioners", cloud_settings_path
      breadcrumbs.add "New", cloud_tool_setting_new_path
   end

  def cloud_tool_setting_create
    logger.debug "#{params.inspect}"
    vault_loc = ((params[:repo_file].original_filename).length > 0) ? cloudtool_base_url+"/"+current_user.email+"/"+params[:repo_name]+"/"+params[:repo_file].original_filename : ""
    #vault_loc = cloudtool_base_url+"/"+current_user.email+"/"+params[:repo_name]+"/"+File.basename(params[:repo_file])
    options = { :cloud_type => params[:cloud_type], :repo_name => params[:repo_name], :repo => params[:repo], :vault_location => vault_loc, :conf_location => "sandy@megamsandbox.com/default_chef/chef-repo/.chef/knife.rb"  }
    @res_body = CreateCloudToolSettings.perform(options, force_api[:email], force_api[:api_key])
    if @res_body.class == Megam::Error
      @res_msg = nil
      @err_msg="Please contact #{ActionController::Base.helpers.link_to 'Our Support !.', "http://support.megam.co/"}."
    else
      @err_msg = nil
      @upload = S3Upload.perform(cloud_tool_setting_bucket, current_user.email+"/"+params[:repo_name]+"/"+params[:repo_file].original_filename, params[:repo_file].read)
      #@upload = S3Upload.perform(cloud_tool_setting_bucket, current_user.email+"/"+params[:repo_name]+"/"+File.basename(params[:repo_file]), :file => params[:repo_file])
      if @upload.class == Megam::Error
        @res_msg = nil
        @err_msg="Failed to upload cloud files. Please contact #{ActionController::Base.helpers.link_to 'Our Support !.', "http://support.megam.co/"}."
        respond_to do |format|
          format.js {
            respond_with(@res_msg, @err_msg, :layout => !request.xhr? )
          }
        end
      else
        @err_msg = nil
        @res_msg = "Cloud Tool Setting created successfully"
        respond_to do |format|
          format.js {
            respond_with(@res_msg, @err_msg, :layout => !request.xhr? )
          }
        end
      end
    end
  end
end
