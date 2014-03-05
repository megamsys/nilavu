class SshKeysController < ApplicationController
  respond_to :html, :js
  include CrossCloudsHelper
  def new
    breadcrumbs.add " Home", "#", :class => "fa fa-home", :target => "_self"
    breadcrumbs.add "Manage Settings", cloud_settings_path, :target => "_self"
    breadcrumbs.add "SSH Keys", cloud_settings_path, :target => "_self"
    breadcrumbs.add "New", new_ssh_key_path, :target => "_self"
  end

  def ssh_key_import
    breadcrumbs.add " Home", "#", :class => "fa fa-home", :target => "_self"
    breadcrumbs.add "Manage Settings", cloud_settings_path, :target => "_self"
    breadcrumbs.add "SSH Keys", ssh_keys_path, :target => "_self"
    breadcrumbs.add "Import", ssh_key_import_path, :target => "_self"
  end

  def create
    #k = SSHKey.generate(:type => params[:key_type], :bits => params[:key_bit].to_i, :comment => current_user.email)    
    k = SSHKey.generate
    if params[:key_name] == ""
      key_name = current_user.first_name
    else
      key_name = params[:key_name]
    end
    @filename = key_name
    private_key_name = key_name+".key"
    public_key_name = key_name+".pub"
    sshpub_loc = vault_base_url+"/"+current_user.email+"/"+key_name
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
      upload = SshKey.perform(options, cross_cloud_bucket)
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
        @res_msg = "SSH key created successfully"
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
    sshpub_loc = vault_base_url+"/"+current_user.email+"/"+key_name
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
      upload = SshKey.upload(options, cross_cloud_bucket)
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
    downloaded_file = S3.download(cross_cloud_bucket, current_user.email+"/"+"#{@filename}")
    if downloaded_file.class == Megam::Error
      @res_msg = nil
      @err_msg="Failed to Download SSH key. Please contact #{ActionController::Base.helpers.link_to 'support !.', "http://support.megam.co/"}."
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
