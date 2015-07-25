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

require 'bcrypt'

class PasswordResetsController < ApplicationController
  include BCrypt

  skip_before_action :require_signin, only: [:edit, :create, :update]
  # #if the email doesn't exist in our system we ask to signup.
  # #if not, we pull the info of the user and do an account update.
  def create
    account = Accounts.new.find_by_email(params[:email])
        if !account.email.nil?
    params[:password_reset_key] = SecureRandom.urlsafe_base64
    params[:password_reset_sent_at] = "#{Time.zone.now}"
    params[:api_key] = account.api_key
    account.update(params) do
      UserMailer.reset(account).deliver_now
    end
        else
                @error=""
       end
  end


  def edit
    @account = Accounts.new.find_by_password_reset_key(params[:id], params[:email])
    @account
  end

  def update
    account = Accounts.new.find_by_password_reset_key(params[:id], params[:email])
    redirect_to signin_path, alert: 'Password reset has expired.' unless account.password_reset_sent_at < 2.hours.ago
    params[:api_key] = account.api_key #just hack, this is the only place we violate before_action: stick_keys
    update = account.update(params) do
      redirect_to root_url, notice: 'Password has been reset!' && return
    end
  end
end
