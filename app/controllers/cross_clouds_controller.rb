class CrossCloudsController < ApplicationController
  respond_to :html, :js
  include CrossCloudsHelper  

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

    #uploaded_io = params[:aws_private_key]
    #File.open(Rails.root.join('public', 'uploads', uploaded_io.original_filename), 'wb') do |file|
    #file.write(uploaded_io.read)
    #end
    puts current_user.email
    vault_loc = get_Vault_server+current_user.email+"/"+params[:name]
    sshpub_loc = get_Vault_server+current_user.email+"/"+params[:name]
    aws_private_key = ((params[:aws_private_key]).present?) ? current_user.email+"/"+params[:name]+"/"+File.basename(params[:aws_private_key]) : ""
    #aws_private_key = ((params[:aws_private_key].original_filename).length > 0) ? current_user.email+"/"+params[:name]+"/"+params[:aws_private_key].original_filename : ""
    options = { :email => current_user.email, :api_key => current_user.api_token, :name => params[:name], :spec => { :type_name => get_provider_value(params[:provider]), :groups => params[:group], :image => params[:image], :flavor => params[:flavour] }, :access => { :ssh_key => params[:ssh_key], :identity_file => aws_private_key, :ssh_user => params[:ssh_user], :vault_location => vault_loc, :sshpub_location => sshpub_loc, :zone => params[:zone] }  }
    @res_body = CreatePredefClouds.perform(options)
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
        upload_options = {:email => current_user.email, :name => params[:name], :aws_private_key => params[:aws_private_key], :aws_access_key => params[:aws_access_key], :aws_secret_key => params[:aws_secret_key], :type => cc_type(params[:provider]), :id_rsa_public_key => params[:id_rsa_public_key]}
        puts "=============================================="
        puts upload_options
        @upload = AmazonCloud.perform(upload_options, cross_cloud_bucket)
      end
      if params[:provider] == "Google cloud Engine"
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
    puts "========================-=\-=\-=\-=\======================"
    puts params.inspect
    @provider = params[:selected_cloud]
    if params[:selected_cloud] == "aws"
      @provider_form_name = "Amazon EC2"
    elsif params[:selected_cloud] == "gce"
      @provider_form_name = "Google cloud Engine"
    elsif params[:selected_cloud] == "hp"
      @provider_form_name = "hp cloud"
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
