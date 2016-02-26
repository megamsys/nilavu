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
class SessionsController < ApplicationController

  skip_before_filter :redirect_to_login_if_required,  only: [:new, :tour, :create]
  

  def new
  end

  def create

    params.require(:email)
    params.require(:password)

    return invalid_credentials if params[:password].length > User.max_password_length

    user = User.new
    user_params.each { |k, v| user.send("#{k}=", v) }

    if user.find_by_email
      unless user.confirm_password?(params[:password])
        invalid_credentials
        return
      end
    else
      invalid_credentials
      return
    end

    user.email_confirmed? ? login(user) : login_not_found(user)
  end

  def destroy
    reset_session
    log_off_user
    render nothing: true
  end

  private

  def user_params
    params.permit(:email, :password, :status)
  end

  def login(user)
    log_on_user(user)
    redirect_with_success(cockpits_path, "login.success")
  end


  def invalid_credentials
    redirect_with_errror(signin_path, "login.incorrect_email_or_password")
  end

  def login_not_found
    redirect_with_error(signup_path, "login.not_approved")
  end

end
