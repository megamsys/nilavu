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

  before_action :stick_keys
  ## get all sshkeys from storage and sort the keys for creating time based
  def index
    logger.debug "> SSH: index"
    @ssh_keys = Sshkeys.new.list(params).ssh_keys
  end

  def create
    logger.debug "> SSH: create"
    puts params.inspect
    params[:sshoption] = Sshkeys::NEW
    Sshkeys.new.create_or_import(params)
    @msg = { title: "SSH", message: "#{params[:ssh_keypair_name]} created successfully. ", redirect: '/ssh_keys', disposal_id: 'create_ssh' }

  end

  ## this downloads a key
  def edit
    params[:download_location] = current_user.email+"_"+"#{params[:id]}"
    downloaded_file = Sshkeys.new.download(params)
    send_file Rails.root.join("#{params[:download_location]}"), :x_sendfile=>true
  end

  ## this imports the ssh keys.
  def update
    logger.debug "> SSH: update"
    params[:sshoption] = Sshkeys::IMPORT
    Sshkeys.new.create_or_import(params)
    @msg = { title: "SSH", message: "#{params[:ssh_keypair_name]} imported successfully. ", redirect: '/ssh_keys', disposal_id: 'import_ssh' }

  end

end
