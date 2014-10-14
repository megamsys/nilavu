class SshKeysController < ApplicationController
  respond_to :html, :js
  include CrossCloudsHelper
  def new

  end

  def ssh_key_import
  end

  def create
    #k = SSHKey.generate(:type => params[:key_type], :bits => params[:key_bit].to_i, :comment => current_user.email)
    k = SSHKey.generate
    sleep 100
    key_name = params[:key_name] || current_user.first_name
    @filename = key_name
    if Rails.configuration.storage_type == "s3"
      sshpub_loc = vault_s3_url+"/"+current_user.email+"/"+key_name
    else
      sshpub_loc = current_user.email+"_"+key_name     #Riak changes
    end
    wparams = { :name => key_name, :path => sshpub_loc }
    @res_body = CreateSshKeys.perform(wparams, force_api[:email], force_api[:api_key])
    if @res_body.class == Megam::Error
      @res_msg = nil
      @err_msg="Please contact #{ActionController::Base.helpers.link_to 'support !.', "http://support.megam.co/"}."
      respond_to do |format|
        format.js {
          respond_with(@res_msg, @err_msg, @filename, :layout => !request.xhr? )
        }
      end
    else
      @err_msg = nil
      options ={:email => current_user.email, :ssh_key_name => key_name, :ssh_private_key => k.private_key, :ssh_public_key => k.ssh_public_key }
      upload = SshKey.perform(options, ssh_files_bucket)
      if upload.class == Megam::Error
        @res_msg = nil
        @err_msg="SSH keys creation failed."
        @public_key = ""
        respond_to do |format|
          format.js {
            respond_with(@res_msg, @err_msg, @filename, :layout => !request.xhr? )
          }
        end
      else
        @err_msg = nil
        @res_msg = "SSH keys created successfully"
        @public_key = k.public_key
        respond_to do |format|
          format.js {
            respond_with(@res_msg, @err_msg, @filename, :layout => !request.xhr? )
          }
        end
      end
    end

  end

  def sshkey_import
    # @filename = params[:ssh_private_key].original_filename
    @filename = params[:key_name]
    key_name = params[:key_name]
    if Rails.configuration.storage_type == "s3"
      sshpub_loc = vault_s3_url+"/"+current_user.email+"/"+key_name
    else
      sshpub_loc = current_user.email+"_"+key_name     #Riak changes
    end
    wparams = { :name => key_name, :path => sshpub_loc }
    @res_body = CreateSshKeys.perform(wparams, force_api[:email], force_api[:api_key])
    if @res_body.class == Megam::Error
      @res_msg = nil
      @err_msg="Please contact #{ActionController::Base.helpers.link_to 'support !.', "http://support.megam.co/"}."
      respond_to do |format|
        format.js {
          respond_with(@res_msg, @err_msg, @filename, :layout => !request.xhr? )
        }
      end
    else
      @err_msg = nil
      options ={:email => current_user.email, :ssh_key_name => key_name, :ssh_private_key => params[:ssh_private_key], :ssh_public_key => params[:ssh_public_key] }
      upload = SshKey.upload(options, ssh_files_bucket)
      if upload.class == Megam::Error
        @res_msg = nil
        @err_msg="Failed to Generate SSH keys. Please contact #{ActionController::Base.helpers.link_to 'support !.', "http://support.megam.co/"}."
        @public_key = ""
        respond_to do |format|
          format.js {
            respond_with(@res_msg, @err_msg, @filename, :layout => !request.xhr? )
          }
        end
      else
        @err_msg = nil
        @res_msg = "SSH key uploaded successfully"
        respond_to do |format|
          format.js {
            respond_with(@res_msg, @err_msg, @filename, :layout => !request.xhr? )
          }
        end
      end
    end
  end

  def download
    @filename = params[:filename]
    options ={:email => current_user.email, :download_location => current_user.email+"/"+"#{@filename}" }
    downloaded_file = SshKey.download(options,ssh_files_bucket)
    if downloaded_file.class == Megam::Error
      @res_msg = nil
      @err_msg="Failed to Download SSH key."
      @public_key = ""
      respond_to do |format|
        format.js {
          respond_with(@res_msg, @err_msg, @filename, :layout => !request.xhr? )
        }
      end
    else
      @err_msg = nil
      @res_msg = "SSH key downloaded successfully"
      send_file Rails.root.join("#{@filename}"), :x_sendfile=>true
    end
  end

end
