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

  SSH_FILES_BUCKET  = 'sshfiles'.freeze
  RIAK = 'riak'.freeze

  IMPORT   = 'SSH_IMPORT'.freeze
  NEW      = 'SSH_NEW'.freeze
  USEOLD   = 'SSH_USEOLD'.freeze
  SAAVI = 'saavi'.freeze

  PRIV_CONTENT_TYPE = 'application/x-pem-key'.freeze
  PUB_CONTENT_TYPE  = 'application/vnd.ms-publisher'.freeze

  attr_reader :ssh_keys

  def initialize
    @ssh_keys = []
    super(true)
  end

  # a helper that creates or imports ssl keys.
  # can be used during a launch or sshkey creation.
  def create_or_import(api_params)    
    api_params[:name] = api_params[:ssh_keypair_name] ||= Sshkeys::SAAVI
    api_params[:path] = api_params[:email] + '_' + api_params[:name]
    case api_params[:sshoption]
    when NEW
      create(api_params)
    when IMPORT
      import(api_params)
    end
    api_params
  end

  # lists the ssh keys for an user and return a hash with name, timestamp.
  def list(api_params, &_block)
    raw = api_request(api_params, SSHKEYS, LIST)
    @ssh_keys = to_hash(raw[:body]) unless raw.nil?
    yield self  if block_given?
    self
  end

  ## rescue and raise as an error.
  def download(api_params, &_block)
    Storage.new(SSH_FILES_BUCKET).download(api_params[:download_location])
  end

  private

  # generate SSH key, use create_or_import instead.
  def create(api_params, &_block)
    keygen = SSHKey.generate
    api_params[:ssh_private_key] = keygen.private_key
    api_params[:ssh_public_key] = keygen.ssh_public_key
    upload(api_params)
    raw = api_request(api_params, SSHKEYS, CREATE)
    yield self if block_given?
    self
  end

  ## import - use create_or_import instead.
  def import(api_params, &_block)
    upload(api_params, true)
    raw = api_request(api_params, SSHKEYS, CREATE)
    yield self if block_given?
  end

  # a private method that take the sshkeys collection and returns a hash
  def to_hash(ssh_keys_collection)
    ssh_keys = []
    ssh_keys_collection.each do |sshkey|
      ssh_keys << { name: sshkey.name, created_at: sshkey.created_at.to_time.to_formatted_s(:rfc822) }
    end
    ssh_keys.sort_by { |vn| vn[:created_at] }
  end

  # For Riak_we upload the key in the format email_ssh_key_name along with the content type
  def upload(api_params, geeHairyContentType = false)
    tmp_key = api_params[:email] + '_' + api_params[:name]
    if geeHairyContentType
      storage  = Storage.new(SSH_FILES_BUCKET)
      storage.upload(tmp_key + '_key', api_params[:ssh_private_key].read, api_params[:ssh_private_key].content_type)
      storage.upload(tmp_key + '_pub', api_params[:ssh_public_key].read, api_params[:ssh_public_key].content_type)
    else
      storage  = Storage.new(SSH_FILES_BUCKET)
      storage.upload(tmp_key + '_key', api_params[:ssh_private_key], PRIV_CONTENT_TYPE)
      storage.upload(tmp_key + '_pub', api_params[:ssh_public_key], PUB_CONTENT_TYPE)
    end
  end
end
