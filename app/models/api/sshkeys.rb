##
## Copyright [2013-2016] [Megam Systems]
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
require 'base64'

module Api
  class Sshkeys < ApiDispatcher

    OLD      = '1'.freeze
    NEW      = '2'.freeze
    PWD      = '3'.freeze
    IMPORT   = '4'.freeze

    attr_accessor :ssh_keys

    def initialize
      @ssh_keys = []
      super(true)
    end

    # a helper that creates or imports ssl keys.
    # can be used during a launch or sshkey creation.
    def create_or_import(api_params)
        api_params[:name] = api_params[:keypairname]

        case api_params[:keypairoption]
        when NEW
            create(api_params)
        when IMPORT
            import(api_params)
        end
        api_params
    end

    # lists the ssh keys for an user and return a hash with name, timestamp.
    def list(api_params)
      raw = api_request(SSHKEYS, LIST, api_params)
      @ssh_keys = to_hash(raw[:body]) unless raw.nil?
    end

    def show(api_params, &_block)
      raw = api_request(SSHKEYS, SHOW, api_params)
      @ssh_keys = to_hash(raw[:body]) unless raw.nil?
      yield self  if block_given?
      self
    end

    ## rescue and raise as an error.
    def download(api_params)
      File.open(File.basename(api_params[:download_location]), 'wb') do |file|
          file.write(api_params["data"])
      end
    end

    private

    # generate SSH key, use create_or_import instead.
    def create(api_params)
      keygen = SSHKey.generate
      api_params[:privatekey] = keygen.private_key
      api_params[:publickey] = keygen.ssh_public_key
      api_request(SSHKEYS, CREATE, api_params)
    end

    ## import - use create_or_import instead.
    def import(api_params)
      #api_params[:privatekey] = api_params[:ssh_private_key].read
      #api_params[:publickey] = api_params[:ssh_public_key].read
      api_params[:publickey] = api_params[:ssh_public_key]
      api_params[:privatekey] = api_params[:ssh_private_key]
      api_request(SSHKEYS, CREATE, api_params)
   end

    # a private method that take the sshkeys collection and returns a hash
    def to_hash(ssh_keys_collection)
      ssh_keys = []
      ssh_keys_collection.each do |sshkey|
        ssh_keys << { name: sshkey.name, privatekey: sshkey.privatekey, publickey: sshkey.publickey, created_at: sshkey.created_at.to_time.to_formatted_s(:rfc822) }
      end
      ssh_keys.sort_by { |vn| vn[:created_at] }
    end
  end
end
