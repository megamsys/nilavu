class CrossCloudsController < ApplicationController
  respond_to :html, :js
  include CrossCloudsHelper  

  def new
     breadcrumbs.add "Home", "#"
    breadcrumbs.add "Manage Settings", cloud_settings_path
    breadcrumbs.add "Clouds", cloud_settings_path
    breadcrumbs.add "New", new_cross_cloud_path
    logger.debug "GOOGLE oauth token ============> "     
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
    logger.debug "CROSS CLOUD CREATE Current User ============> "
    logger.debug current_user.inspect
    
    logger.debug "CROSS CLOUD CREATE Private Key ============> "
    logger.debug params[:private_key].inspect
    
    vault_loc = vault_base_url+"/"+current_user.email+"/"+params[:name]
    sshpub_loc = vault_base_url+"/"+current_user.email+"/"+params[:name]
    #private_key = (params[:private_key]) ? cross_cloud_bucket+"/"+current_user.email+"/"+params[:name]+"/"+File.basename(params[:private_key]) : ""
    private_key = ((params[:private_key].original_filename).length > 0) ? cross_cloud_bucket+"/"+current_user.email+"/"+params[:name]+"/"+params[:private_key].original_filename : ""
    wparams = {:name => params[:name], :spec => { :type_name => get_provider_value(params[:provider]), :groups => params[:group],  :image => params[:image], :flavor => params[:flavor], :tenant_id => params[:tenant_id]}, :access => { :ssh_key => params[:ssh_key], :identity_file => private_key, :ssh_user => params[:ssh_user], :vault_location => vault_loc, :sshpub_location => sshpub_loc, :zone => params[:zone], :region => params[:region] }  }
    
    if params[:provider] == "profitbricks"
    	wparams[:spec][:flavor] = "cpus=#{params[:cpus]},ram=#{params[:ram]},hdd-size=#{params[:flavor]}"
    end
    @res_body = CreatePredefClouds.perform(wparams,force_api[:email], force_api[:api_key])
    if @res_body.class == Megam::Error
      @res_msg = nil
      @err_msg="Please contact #{ActionController::Base.helpers.link_to 'Our Support !.', "http://support.megam.co/"}."
      respond_to do |format|
        format.js {
          respond_with(@res_msg, @err_msg, :layout => !request.xhr? )
        }
      end
    else
      @err_msg = nil
      if params[:provider] == "Amazon EC2"
        upload_options = {:email => current_user.email, :name => params[:name], :private_key => params[:private_key], :aws_access_key => params[:aws_access_key], :aws_secret_key => params[:aws_secret_key], :type => cc_type(params[:provider]), :id_rsa_public_key => params[:id_rsa_public_key]}
        @upload = AmazonCloud.perform(upload_options, cross_cloud_bucket)
      end
      if params[:provider] == "hp cloud"
        upload_options = {:email => current_user.email, :name => params[:name], :private_key => params[:private_key], :hp_access_key => params[:hp_access_key], :hp_secret_key => params[:hp_secret_key], :type => cc_type(params[:provider]), :id_rsa_public_key => params[:id_rsa_public_key]}
        
        @upload = HpCloud.perform(upload_options, cross_cloud_bucket)
      end
      
      if params[:provider] == "profitbricks"
        upload_options = {:email => current_user.email, :name => params[:name], :private_key => params[:private_key], :profitbricks_username => params[:profitbricks_username], :profitbricks_password => params[:profitbricks_password], :type => cc_type(params[:provider]), :id_rsa_public_key => params[:id_rsa_public_key]}
        @upload = ProfitbricksCloud.perform(upload_options, cross_cloud_bucket)
      end
      
      if params[:provider] == "Google Compute Engine"
        if params[:access_token].length > 0
          @data = CreateGoogleJSON.perform(params[:access_token], params[:refresh_token], params[:expire], params[:project_name], params[:google_client_id], params[:google_secret_key])
        end        
        upload_options = {:email => current_user.email, :name => params[:name], :provider_value => get_provider_value(params[:provider]), :type => cc_type(params[:provider]), :g_json => @data, :id_rsa_public_key => params[:id_rsa_public_key]}
        @upload = GoogleCloud.perform(upload_options, cross_cloud_bucket)
      end
      if @upload.class == Megam::Error
        @res_msg = nil
        @err_msg="Failed to upload cross cloud files. Please contact #{ActionController::Base.helpers.link_to 'Our Support !.', "http://support.megam.co/"}."
        respond_to do |format|
          format.js {
            respond_with(@res_msg, @err_msg, :layout => !request.xhr? )
          }
        end
      else
        @res_msg= "Cross cloud defintion :"+ params[:name] + " created successfully."
        respond_to do |format|
          format.js {
            respond_with(@res_msg, @err_msg, :layout => !request.xhr? )
          }
        end
      end
    end
  #redirect_to cross_clouds_path, :gflash => { :warning => { :value => "CROSS  CLOUD CREATION DONE ", :sticky => false, :nodom_wrap => true } }

  end
  
  def cloud_selector
    @provider = params[:selected_cloud]
    if params[:selected_cloud] == "aws"
      @provider_form_name = "Amazon EC2"
    elsif params[:selected_cloud] == "gce"
      @provider_form_name = "Google Compute Engine"
    elsif params[:selected_cloud] == "hp"
      @provider_form_name = "hp cloud"
    elsif params[:selected_cloud] == "profitbricks"
      @provider_form_name = "profitbricks"
    else
      @provider_form_name = "Amazon EC2"
    end
    respond_to do |format|
      format.js {
        respond_with(@provider, @provider_form_name, :layout => !request.xhr? )
      }
    end
  end
end
