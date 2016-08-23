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
require 'sshkeys_finder'

class SshKeysController < ApplicationController
  respond_to :html, :js, :json

  before_action :add_authkeys_for_api, only: [:index, :create, :edit, :import, :show]

  def index
    @foundkeys ||= SSHKeysFinder.new(params).foundkeys
    respond_to do |format|
        if @foundkeys
            format.json { render json: {
              success: true,
              message: @foundkeys,
            } }
        else
            format.json { render json: {
              success: false,
              message: I18n.t(
                'ssh_keys.download_error',
              )
            } }
        end
    end
  end

  def create
    params[:keypairoption] = Api::Sshkeys::NEW
    Api::Sshkeys.new.create_or_import(params)
    render json: {
      success: true,
      message: I18n.t('ssh_keys.create_success')
    }
  end

  def show
    @ssh = Api::Sshkeys.new.show(params)

    respond_to do |format|
        if @ssh
            format.json { render json: {
              success: true,
              message: @ssh,
            } }
        else
            format.json { render json: {
              success: false,
              message: I18n.t(
                'ssh_keys.download_error',
              )
            } }
        end
    end
  rescue ApiDispatcher::NotReached
    render json: {
      success: false,
      message: I18n.t("login.something_already_taken")
    }
 end


  ## this downloads a key
  def edit
    if params[:format]
    params.merge!({:download_location => "#{params[:name]}.#{params[:format]}"})
  else
    params.merge!({:download_location => "#{params[:name]}"})
  end
    Api::Sshkeys.new.download(params)
    send_file Rails.root.join("#{params[:download_location]}"), :x_sendfile=>true
  end

  ## this imports the ssh keys.
  def import
    params[:keypairoption] = Api::Sshkeys::IMPORT
    Api::Sshkeys.new.create_or_import(params)
    render json: {
      success: true,
      message: "#{params[:keypairname]} #{I18n.t('ssh_keys.import_success')}",
    }
  end
end
