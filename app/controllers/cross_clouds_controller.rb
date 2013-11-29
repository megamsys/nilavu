class CrossCloudsController < ApplicationController
  respond_to :html, :js
  include CrossCloudsHelper
  add_breadcrumb "Dashboard", :dashboards_path
  def index
    add_breadcrumb "Cross Clouds", cross_clouds_path
    cross_cloud_options = { :email => current_user.email, :api_key => current_user.api_token }
    @cross_clouds_collection = ListPredefClouds.perform(cross_cloud_options)
    if @cross_clouds_collection.class == Megam::Error
      redirect_to dashboards_path, :gflash => { :warning => { :value => "Oops! sorry, #{@cross_clouds_collection.some_msg[:msg]}", :sticky => false, :nodom_wrap => true } }
    end
    @cross_clouds = []
    @cross_clouds_collection.each do |pre_cl|
      @cross_clouds << {:name => pre_cl.name, :created_at => pre_cl.created_at.to_time.to_formatted_s(:rfc822)}
    end
    @cross_clouds = @cross_clouds.sort_by {|vn| vn[:created_at]}
    puts "============================> @CROSS CLOUD INDEX <==================================="
    puts @cross_clouds.inspect
  end

  def new
    add_breadcrumb "Cross Clouds", cross_clouds_path
    add_breadcrumb "New Cross Cloud", new_cross_cloud_path
    logger.debug "GOOGLE oauth token ============> "
    puts request.env['omniauth.auth']
    if request.env['omniauth.auth']
      @cloud_prov = "Google Cloud Engine"
      @token = request.env['omniauth.auth']['credentials']['token']
      @refresh_token = request.env['omniauth.auth']['credentials']['refresh_token']
      @expire = request.env['omniauth.auth']['credentials']['expires_at']
    else
      @cloud_prov = "Amazon EC2"
    end
  end

  def create
    logger.debug "CROSS CLOUD CREATE PARAMS ============> "
    logger.debug "#{params}"
    if params[:access_token].length > 0     
      CreateGoogleJSON.perform(params[:access_token], params[:refresh_token], params[:expire], params[:project_name], params[:google_client_id], params[:google_secret_key])
    end
    vault_loc = get_Vault_server+current_user.email+"/"+params[:name]
    options = { :email => current_user.email, :api_key => current_user.api_token, :name => params[:name], :spec => { :type_name => get_provider_value(params[:provider]), :groups => params[:group], :image => params[:image], :flavor => params[:flavour] }, :access => { :ssh_key => params[:ssh_key], :identity_file => File.basename(params[:aws_private_key]), :ssh_user => params[:ssh_user], :vault_location => vault_loc }  }
    @res_body = CreatePredefClouds.perform(options)
    if @res_body.class == Megam::Error
      @res_msg = nil
      @err_msg="Sorry Something Wrong. Please contact #{ActionController::Base.helpers.link_to 'Our Support !.', "http://support.megam.co/"}."
      respond_to do |format|
        format.js {
          respond_with(@res_msg, @err_msg, :layout => !request.xhr? )
        }
      end
    else
      @err_msg = nil
      upload_option = {:email => current_user.email, :name => params[:name], :aws_private_key => params[:aws_private_key], :aws_access_key => params[:aws_access_key], :aws_secret_key => params[:aws_secret_key], :type => cc_type(params[:provider]), :id_rsa_public_key => params[:id_rsa_public_key]}
      puts "=============================================="
      puts upload_option
      #aws_upload = S3Upload.perform(params[:aws_private_key], current_user.email+"/"+params[:name])
      @aws_upload = S3Upload.perform(upload_option)
      if @aws_upload.class == Megam::Error
        @res_msg = nil
        @err_msg="Cross Cloud Files uploading was failed. Please contact #{ActionController::Base.helpers.link_to 'Our Support !.', "http://support.megam.co/"}."
        respond_to do |format|
          format.js {
            respond_with(@res_msg, @err_msg, :layout => !request.xhr? )
          }
        end
      else
        @res_msg= "Cross cloud predefintion <"+ params[:name] + "> created successfully."
        respond_to do |format|
          format.js {
            respond_with(@res_msg, @err_msg, :layout => !request.xhr? )
          }
        end
      end
    end
  #redirect_to cross_clouds_path, :gflash => { :warning => { :value => "CROSS  CLOUD CREATION DONE ", :sticky => false, :nodom_wrap => true } }
  end

  def show
    cross_cloud_options = { :email => current_user.email, :api_key => current_user.api_token }
    @cross_clouds = ListPredefClouds.perform(cross_cloud_options)
    @cross_cloud = @cross_clouds.lookup(params[:id])
  end
end
