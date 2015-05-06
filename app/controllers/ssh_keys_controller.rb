##
## Copyright [2013-2015] [Megam Systems]
##
## Licensed under the Apache License, Version 2.0 (the "License");
## you may not use this file except in compliance with the License.
## You may obtain a copy of the License at
##
## http://www.apache.org/licenses/LICENSE-2.0
##
## Unless required by applicable law or agreed to in writing, software
## distributed under the License is distributed on an "AS IS" BASIS,
## WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
## See the License for the specific language governing permissions and
## limitations under the License.
##
class SshKeysController < ApplicationController
  respond_to :html, :js
  include CrossCloudsHelper

  def new

  end

  ##
  ## get all sshkeys from storage and sort the keys for creating time based
  ##
  def index
    logger.debug "> SSH: index"
    @ssh_keys = Sshkeys.new.ssh_keys        
  end

  def ssh_key_import
  end

  def create
      #k = SSHKey.generate(:type => params[:key_type], :bits => params[:key_bit].to_i, :comment => current_user.email)
      k = SSHKey.generate
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
          @err_msg="SSH key #{key_name} creation failed."
          @public_key = ""
          respond_to do |format|
            format.js {
              respond_with(@res_msg, @err_msg, @filename, :layout => !request.xhr? )
            }
          end
        else
          @err_msg = nil
          @res_msg = "SSH key #{key_name} created successfully"
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
          @res_msg = "SSH key imported successfully"
          respond_to do |format|
            format.js {
              respond_with(@res_msg, @err_msg, :layout => !request.xhr? )
            }
          end
        end
      end
  end

  def download
      @keyname = params[:filename]
      @filename = current_user.email+"_"+"#{@keyname}"
      options ={:email => current_user.email, :download_location => "#{@filename}" }
      downloaded_file = SshKey.download(options, ssh_files_bucket)
      if downloaded_file.class == Megam::Error
        @res_msg = nil
        @err_msg="Failed to Download SSH key."
        @public_key = ""
        respond_to do |format|
          format.js {
            respond_with(@res_msg, @err_msg, @keyname, :layout => !request.xhr? )
          }
        end
      else
        @err_msg = nil
        @res_msg = "SSH key downloaded successfully"
        send_file Rails.root.join("#{@filename}"), :x_sendfile=>true
      end
    end

end
