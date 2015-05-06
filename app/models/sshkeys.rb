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
class Sshkeys < BaseFascade
  include SshHelper

  
  S3   = "s3"
  RIAK = "riak"

  attr_reader :ssh_keys
  def initialize()
    @ssh_keys = []
    @key_name = nil
    super(true)
  end

  #lists the ssh keys for an user and return a hash with name, timestamp.
  def list(api_params, &block)
    raw = api_request(api_params, SSHKEYS, LIST)
    @ssh_keys = to_hash(raw[:body]) unless raw == nil
    yield self  if block_given?
    return self
  end

  #gemerate SSH key
  def create(api_params, &block)

    SSHKey.generate
    key_name = params[:key_name] || current_user.first_name

    @filename = key_name


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

  private

  #
  def ssh_public_location
    if Rails.configuration.storage_type == "s3"
      sshpub_loc = vault_s3_url+"/"+current_user.email+"/"+key_name
    else
      sshpub_loc = current_user.email+"_"+key_name     #Riak changes
    end
  end

  #a private method that take the sshkeys collection and returns a hash
  def to_hash(ssh_keys_collection)
    ssh_keys = []
    ssh_keys_collection.each do |sshkey|
      ssh_keys << {:name => sshkey.name, :created_at => sshkey.created_at.to_time.to_formatted_s(:rfc822)}
    end
    ssh_keys.sort_by {|vn| vn[:created_at]}
  end

  def create(params, &block)
    case params[:sshoption]
    when "CREATE"
      begin
        k = SSHKey.generate
        @key_name = params[:sshcreatename] + "_" + params[:name]
        options ={:email => params[:email], :ssh_key_name => @key_name, :ssh_private_key => k.private_key, :ssh_public_key => k.ssh_public_key }
        SshKey.perform(options, ssh_files_bucket)
      rescue Sshkeys::SSHKeyUploadFailure => se
        @error   = se.message
      end
    when "UPLOAD"
      begin
        @key_name = params[:sshuploadname] + "_" + params[:name]
        options ={:email => params[:email], :ssh_key_name => key_name, :ssh_private_key => params[:ssh_private_key], :ssh_public_key => params[:ssh_public_key] }
        upload = SshKey.upload(options, ssh_files_bucket)
      rescue Sshkeys::SSHKeyUploadFailure => se
        @error   = se.message
      end
    when "EXIST"
      @key_name = params[:sshexistname]
    end
    yield self if block_given?
    return self
  end

  def upload(api_params)
    if Rails.configuration.storage_type == "s3"
      sshpub_loc = vault_s3_url+"/"+current_user.email+"/"+@key_name
    else
      sshpub_loc = current_user.email+"_"+@key_name     #Riak changes
    end
    api_request(api_params.merge({:name => @key_name, :path => sshpub_loc }), SSHKEYS, CREATE)
    yield self if block_given?
    return self
  end

end
