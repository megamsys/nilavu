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
    else
      @cross_clouds = []
      cross_clouds = []
      @cross_clouds_collection.each do |pre_cl|
        cross_clouds << {:name => pre_cl.name, :created_at => pre_cl.created_at.to_time.to_formatted_s(:rfc822)}
      end
      @cross_clouds = cross_clouds.sort_by {|vn| vn[:created_at]}
      puts "============================> @CROSS CLOUD INDEX <==================================="
      puts @cross_clouds.inspect
    end
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

    #uploaded_io = params[:picture]
    #File.open(Rails.root.join('public', 'uploads', uploaded_io.original_filename), 'wb') do |file|
    #file.write(uploaded_io.read)
    #end
    puts current_user.email
    vault_loc = get_Vault_server+current_user.email+"/"+params[:name]
    sshpub_loc = get_Vault_server+current_user.email+"/"+params[:name]
    aws_private_key = ((params[:aws_private_key].original_filename).length > 0) ? current_user.email+"/"+params[:name]+"/"+params[:aws_private_key].original_filename : ""
    options = { :email => current_user.email, :api_key => current_user.api_token, :name => params[:name], :spec => { :type_name => get_provider_value(params[:provider]), :groups => params[:group], :image => params[:image], :flavor => params[:flavour] }, :access => { :ssh_key => params[:ssh_key], :identity_file => private_key, :ssh_user => params[:ssh_user], :vault_location => vault_loc, :sshpub_location => sshpub_loc }  }
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
        @upload = AmazonCloud.perform(upload_options)
      end
      if params[:provider] == "Google cloud Engine"
        if params[:access_token].length > 0
          @data = CreateGoogleJSON.perform(params[:access_token], params[:refresh_token], params[:expire], params[:project_name], params[:google_client_id], params[:google_secret_key])
        end
        upload_options = {:email => current_user.email, :name => params[:name], :type => cc_type(params[:provider]), :g_json => @data, :id_rsa_public_key => params[:id_rsa_public_key]}
        @upload = GoogleCloud.perform(upload_options)
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

  def show
    cross_cloud_options = { :email => current_user.email, :api_key => current_user.api_token }
    @cross_clouds = ListPredefClouds.perform(cross_cloud_options)
    @cross_cloud = @cross_clouds.lookup(params[:id])
  end

  def cloud_selector
    puts "========================-=\-=\-=\-=\======================"
    puts params.inspect
    @provider = params[:selected_cloud]
    if params[:selected_cloud] == "Amazon EC2"
      @provider_form_name = "aws"
    elsif params[:selected_cloud] == "Google cloud Engine"
      @provider_form_name = "google"
    elsif params[:selected_cloud] == "hp cloud"
      @provider_form_name = "hp"
    else
      @provider_form_name = "aws"
    end
    respond_to do |format|
      format.js {
        respond_with(@provider, @provider_form_name, :layout => !request.xhr? )
      }
    end
  end
end
