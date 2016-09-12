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

  skip_before_filter :redirect_to_login_if_required

  def csrf
    render json: {csrf: form_authenticity_token }
  end

  def create
    unless allow_local_auth?
      render nothing: true, status: 500
      return
    end

    params.require(:email)
    params.require(:password)

    return invalid_credentials if params[:password].length > User.max_password_length

    user = User.new
    user_params.each { |k, v| user.send("#{k}=", v) }
    if user = user.find_by_email_password
      unless user.confirm_password?(params[:password])
        invalid_credentials
        return
      end
    else
      invalid_credentials
      return
    end
    user.email_confirmed? ? login(user) : not_activated(user)
  rescue ApiDispatcher::Flunked
    invalid_credentials
  end


  def forgot_password
    unless allow_local_auth?
      render nothing: true, status: 500
      return
    end
    params.permit(:login)

    user = User.new
    user.email = params[:login]

    if user.forgot
      render json: success_json
    else
      render_json_error(I18n.t("password_reset.no_token"))
    end
  end

  def current
    if current_user.present?
      render_serialized(current_user)
    else
      render nothing: true, status: 404
    end
  end

  ## this should be moved to an anonymous user, with anonymous_homepage handled using Guardian
  def tour
    params.merge!({:email => 'tour@megam.io', :password => 'faketour'})
    create
  end

  def destroy
    reset_session
    log_off_user
    render nothing: true
  end

  def current
    if current_user.present?
      render_serialized(current_user, CurrentUserSerializer)
    else
      render nothing: true, status: 404
    end
  end


  private

  def user_params
    params.permit(:email, :password, :status)
  end

  def allow_local_auth?
    !SiteSetting.enable_sso && SiteSetting.enable_local_logins
  end

  def invalid_credentials
    render json: {error: I18n.t("login.incorrect_email_or_password")}
  end

  def not_activated(user)
    render json: {
      error: I18n.t("login.not_activated"),
      reason: 'not_activated',
      sent_to_email: user.email,
      current_email: user.email
    }
  end

  def login(user)
    log_on_user(user)
    #TO-DO    render_serialized(user, UserSerializer)
    render json: success_json
  end
end
