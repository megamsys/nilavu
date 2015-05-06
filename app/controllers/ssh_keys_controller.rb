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
    Sshkeys.new.create(params)
  end

  def edit
    params[:download_location] = current_user.email+"_"+"#{params[:filename]}"
    Sshkeys.new.download(params)
    downloaded_file = SshKey.download(options, ssh_files_bucket)
    send_file Rails.root.join("#{params[:download_location]}"), :x_sendfile=>true
  end
  
  def update
    Sshkeys.new.import(params)
  end



end
