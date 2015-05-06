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

  attr_reader :ssh_keys
  def initialize()
    @ssh_keys = []
    super(true)
  end

  def list(api_params, &block)
    raw = api_request(api_params, SSHKEYS, LIST)
    @ssh_keys = filterkeys(raw[:body]) unless raw == nil
    yield self  if block_given?
    return self
  end

  private

  def filterkeys(ssh_keys_collection)
    ssh_keys = []
    ssh_keys_collection.each do |sshkey|
      ssh_keys << {:name => sshkey.name, :created_at => sshkey.created_at.to_time.to_formatted_s(:rfc822)}
    end
    ssh_keys.sort_by {|vn| vn[:created_at]}
  end

  def create(params, &block)
    k = SSHKey.generate
    key_name = params[:sshname] + "_" + params[:name] 
    sshkeyname = key_name
    filename = key_name
    if Rails.configuration.storage_type == "s3"
      sshpub_loc = vault_s3_url+"/"+current_user.email+"/"+key_name
    else
      sshpub_loc = current_user.email+"_"+key_name     #Riak changes
    end
    # wparams = { :name => key_name, :path => sshpub_loc }
    api_request(params.merge({ :name => key_name, :path => sshpub_loc }), SSHKEYS, CREATE)
    yield self if block_given?
    return self
  end
  
  def upload(api_params, &block)
    options ={:email => current_user.email, :ssh_key_name => key_name, :ssh_private_key => k.private_key, :ssh_public_key => k.ssh_public_key }
    upload = SshKey.perform(options, ssh_files_bucket)
  end

end
