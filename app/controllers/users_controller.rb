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

class UsersController < ApplicationController

  skip_before_filter :redirect_to_login_if_required, only: [:new, :create]
  before_action :add_authkeys_for_api, only: [:edit, :update]


  def new
  end

  def show
  end

  def create
    if params[:email] && params[:email].length > 254 + 1 + 253
      return fail_with("login.email_too_long")
    end

    #if SiteSetting.reserved_emailnames.split("|").include? params[:email].downcase
    #  return fail_with("login.reserved_email")
    #end

    user = User.new

    user_params.each { |k, v| user.send("#{k}=", v) }

    user.password = SecureRandom.hex if user.password.blank?
    user.api_key = SecureRandom.hex(20) if user.api_key.blank?

    activation = UserActivator.new(user, request, session, cookies)
    activation.start

    if user.save
      activation.finish

      session["account_created_message"] = activation.message
      redirect_with_success(cockpits_path, "account_created_message")
    else
      session["account_created_message"] = activation.message
      redirect_with_failure(cockpits_path, "login.errors", account.errors.full_messages.join("\n"))
    end
    # rescue ActiveRecord::StatementInvalid
    #render json: {
    #  success: false,
    #  message: I18n.t("login.something_already_taken")
    #}
    #rescue RestClient::Forbidden
    #render json: { errors: [I18n.t("nilavu.access_token_problem")] }
  end

  # Used for checking availability of an email
  # will return error if the email is available.
  #def check_username
  #  checker = EmailCheckerService.new
  #  email = params[:email]
  #  render json: checker.check_email(email)
  #end


  def fail_with(key)
    render json: { success: false, message: I18n.t(key) }
  end

  def user_params
    params.permit(:email, :password, :first_name, :last_name, :status)
  end
end
