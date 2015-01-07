class CloudToolSettingsController < ApplicationController
  respond_to :html, :js
  include CrossCloudsHelper
  
  def new

  end

  def create
    logger.debug "#{params.inspect}"
    vault_loc = ((params[:repo_file].original_filename).length > 0) ? cloudtool_base_url+"/"+current_user["email"]+"/"+params[:repo_name]+"/"+params[:repo_file].original_filename : ""
    #vault_loc = cloudtool_base_url+"/"+current_user["email"]+"/"+params[:repo_name]+"/"+File.basename(params[:repo_file])
    options = { :cloud_type => params[:cloud_type], :repo_name => params[:repo_name], :repo => params[:repo], :vault_location => vault_loc, :conf_location => "sandy@megamsandbox.com/default_chef/chef-repo/.chef/knife.rb"  }
    @res_body = CreateCloudToolSettings.perform(options, force_api[:email], force_api[:api_key])
    if @res_body.class == Megam::Error
      @res_msg = nil
      @err_msg="Please contact #{ActionController::Base.helpers.link_to 'support !.', "http://support.megam.co/"}."
    else
      @err_msg = nil
      @upload = S3.upload(cloud_tool_setting_bucket, current_user["email"]+"/"+params[:repo_name]+"/"+params[:repo_file].original_filename, params[:repo_file].read)
      #@upload = S3.upload(cloud_tool_setting_bucket, current_user["email"]+"/"+params[:repo_name]+"/"+File.basename(params[:repo_file]), :file => params[:repo_file])
      if @upload.class == Megam::Error
        @res_msg = nil
        @err_msg="Failed to upload cloud files. Please contact #{ActionController::Base.helpers.link_to 'support !.', "http://support.megam.co/"}."
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
  
  def show
    @cts_msg = params[:type]
      @cc_msg = nil
      #@cloud_tool_settings = ListCloudToolSettings.perform(force_api[:email], force_api[:api_key])
      #@cloud_tool_setting = @cloud_tool_settings.lookup(params[:id])
       respond_to do |format|
      format.js {
        respond_with(@cc_msg, @cts_msg, @cross_cloud, :layout => !request.xhr? )
      }
    end    
  end
  
end
