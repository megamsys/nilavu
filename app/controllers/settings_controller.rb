class SettingsController < ApplicationController


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

  def ssh_key_init
    @ssh_keys_collection = ListSshKeys.perform(force_api[:email], force_api[:api_key])
    if @ssh_keys_collection.class != Megam::Error
      @ssh_keys = []
      ssh_keys = []
      @ssh_keys_collection.each do |sshkey|
        ssh_keys << {:name => sshkey.name, :created_at => sshkey.created_at.to_time.to_formatted_s(:rfc822)}
      end
      @ssh_keys = ssh_keys.sort_by {|vn| vn[:created_at]}
    end
  end

  def index

    cross_cloud_init
    #cloud_tools_init
    ssh_key_init
    if @cloud_tool_setting_collection.class == Megam::Error && @cross_clouds_collection.class == Megam::Error
      redirect_to main_dashboards_path, :gflash => { :warning => { :value => "API server may be down. Please contact #{ActionController::Base.helpers.link_to 'support !.', "http://support.megam.co/", :target => "_blank"}.", :sticky => false, :nodom_wrap => true } }
    elsif @cross_clouds_collection.class == Megam::Error
      redirect_to main_dashboards_path, :gflash => { :warning => { :value => "API server may be down. Please contact #{ActionController::Base.helpers.link_to 'support !.', "http://support.megam.co/", :target => "_blank"}.", :sticky => false, :nodom_wrap => true } }
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
    end
    respond_to do |format|
      format.js {
        respond_with(@cc_msg, @cts_msg, @cross_cloud, @cloud_tool_setting, :layout => !request.xhr? )
      }
    end
  end

end
