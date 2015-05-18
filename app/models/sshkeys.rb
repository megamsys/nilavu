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
  include SshKeysHelper

  S3   = "s3".freeze
  RIAK = "riak".freeze

  IMPORT   = "SSH_IMPORT".freeze
  NEW      = "SSH_NEW".freeze
  USEOLD   = "SSH_USEOLD".freeze
  SAAVI = "saavi".freeze

  PRIV_CONTENT_TYPE = "application/x-pem-key".freeze
  PUB_CONTENT_TYPE  = "application/vnd.ms-publisher".freeze

  attr_reader :ssh_keys
  def initialize()
    @ssh_keys = []
    @ssh_public_path = nil
    super(true)
  end

  #a helper that creates or imports ssl keys.
  #can be used during a launch or sshkey creation.
  def create_or_import(api_params)

    api_params[:name] = api_params[:ssh_keypair_name] + '_' + api_params[:name] ||= Sshkeys::SAAVI

    puts api_params[:ssh_keypair_name]
    create(api_params) and return api_params if api_params[:sshoption] == Sshkeys::NEW
    import(api_params) unless api_params[:sshoption] == Sshkeys::USEOLD
    api_params
  end

  #lists the ssh keys for an user and return a hash with name, timestamp.
  def list(api_params, &block)
    raw = api_request(api_params, SSHKEYS, LIST)
    @ssh_keys = to_hash(raw[:body]) unless raw == nil
    yield self  if block_given?
    return self
  end

  ## rescue and raise as an error.
  def download(api_params, &block)
    case Rails.configuration.storage_type
    when S3
      S3.download(ssh_files_bucket, api_params[:download_location])
    when RIAK
      MegamRiak.download(ssh_files_bucket, api_params[:download_location])
    else
    raise UnsupportedConfigError, "Unsupported storage type in nilavu.yml. Supported storage types are [S3, Riak]. "
    end
  end

  private

  #generate SSH key, use create_or_import instead.
  def create(api_params, &block)
    set_pub_path(api_params)
    keygen   = SSHKey.generate
    api_params[:ssh_private_key] = keygen.private_key
    api_params[:ssh_public_key]  = keygen.ssh_public_key
    api_params[:path]            = @ssh_public_path
    upload(api_params)
    raw = api_request(api_params, SSHKEYS, CREATE)

    yield self if block_given?
    self
  end

  ## import - use create_or_import instead.
  def import(api_params, &block)
    set_pub_path(api_params)
    api_params[:path]            = @ssh_public_path
    upload(api_params, true)
    raw = api_request(api_params, SSHKEYS, CREATE)
    yield self if block_given?
  end

  #a private method that take the sshkeys collection and returns a hash
  def to_hash(ssh_keys_collection)
    ssh_keys = []
    ssh_keys_collection.each do |sshkey|
      ssh_keys << {:name => sshkey.name, :created_at => sshkey.created_at.to_time.to_formatted_s(:rfc822)}
    end
    ssh_keys.sort_by {|vn| vn[:created_at]}
  end

  #For S3 we upload ?
  #For Riak_we upload the key in the format email_ssh_key_name along with the content type
  def set_pub_path(api_params)
    case Rails.configuration.storage_type
    when S3
      @ssh_public_path = vault_s3_url+"/"+ api_params[:email]+"/"+params[:name]
    when RIAK
      @ssh_public_path = api_params[:email]+"_"+api_params[:name]
    else
    raise UnsupportedConfigError, "Unsupported storage type in nilavu.yml. Supported storage types are [S3, Riak]. "
    end
  end

  #For S3 we upload ?
  #For Riak_we upload the key in the format email_ssh_key_name along with the content type
  def upload(api_params, bufferedUpload = false)
    raise UnsupportedConfigError, "Please configure the sshfile bucket to store in nilavu.yml" unless ssh_files_bucket
    case Rails.configuration.storage_type
    when S3
      if bufferedUpload
        S3.upload(ssh_files_bucket, api_params[:email]+"/"+api_params[:name]+".key", api_params[:ssh_private_key].read)
        S3.upload(ssh_files_bucket, api_params[:email]+"/"+api_params[:name]+".pub", api_params[:ssh_public_key].read)
      else
        S3.upload(ssh_files_bucket, api_params[:email]+"/"+api_params[:name] +".key", api_params[:ssh_private_key])
        S3.upload(ssh_files_bucket, api_params[:email]+"/"+api_params[:name] +".pub", api_params[:ssh_public_key])
      end
    when RIAK
      if bufferedUpload
        MegamRiak.upload(ssh_files_bucket, api_params[:email]+"_"+api_params[:name]+"_key", api_params[:ssh_private_key].read, api_params[:ssh_private_key].content_type)
        MegamRiak.upload(ssh_files_bucket, api_params[:email]+"_"+api_params[:name]+"_pub", api_params[:ssh_public_key].read, api_params[:ssh_public_key].content_type)
      else
        MegamRiak.upload(ssh_files_bucket, api_params[:email]+"_"+api_params[:name] +"_key", api_params[:ssh_private_key], PRIV_CONTENT_TYPE)
        MegamRiak.upload(ssh_files_bucket, api_params[:email]+"_"+api_params[:name] +"_pub", api_params[:ssh_public_key], PUB_CONTENT_TYPE)
      end
    else
    raise UnsupportedConfigError, "Unsupported storage type in nilavu.yml. Supported storage types are [S3, Riak]. "
    end
  end

end
