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
  respond_to :html, :js

  skip_before_filter :redirect_to_login_if_required, only: [:new, :create,
  :forgot_password, :password_reset]

  before_action :add_authkeys_for_api, only: [:edit,:update]


  def new
  end

  def show
  end

  def create
    if params[:email] && params[:email].length > 254 + 1 + 253
      return fail_with("login.email_too_long")
    end

    if SiteSetting.reserved_emails.split("|").include? params[:email].downcase
      return fail_with("login.reserved_email")
    end

    user = User.new

    user_params.each { |k, v| user.send("#{k}=", v) }

    user.api_key = SecureRandom.hex(20) if user.api_key.blank?

    authentication = UserAuthenticator.new(user, session)

    if !authentication.has_authenticator? && !SiteSetting.enable_local_logins
      return render nothing: true, status: 500
    end

    authentication.start

    activation = UserActivator.new(user, request, session, cookies)
     activation.start


    # just assign a password if we have an authenticator and no password, this is the case for oauth maybe
    user.password = SecureRandom.hex if user.password.blank? && authentication.has_authenticator?

    if user.save
      authentication.finish
      activation.finish

      session["signup.created_account"] = activation.message
      redirect_with_success(cockpits_path, "signup.created_account")
    else
      session["signup.create_failure"] = activation.message
      redirect_with_failure(signin_path, "login.error", user.errors.full_messages.join("\n"))
    end
    #TO-DO rescure connection errors that come out.
    #rescue RestClient::Forbidden
    #redirect_with_failure(cockpits_path, ""nilavu.access_token_problem")
  end

  # load the current org details and send it the edit.html.erb.
  def edit
    @orgs = Teams.new.tap do |teams|
      teams.find_all(params)
    end
  end

  def update
    user = fetch_user_from_params

    unless check_password(user, params)
      redirect_with_failure(edit_user_path(1), "login.incorrect_password")
      return
    end

    updater = UserUpdater.new(user)
    if updater.update(params)
      activation = UserActivator.new(user, request, session, cookies)
      activation.start
      activation.finish

      redirect_with_success(edit_user_path(1), "signup.updated_profile")
    else
      redirect_with_failure(edit_user_path(1), "login.errors", "errors.profile_error")
    end
  end

  def forgot_password
    params.permit(:email)
    user = User.new
    user.email = params[:email]
    if user.reset
      redirect_with_success(signin_path, "forgot_password.success")
    else
      fail_with("forgot_password.errors")
    end
  end

  def password_reset
    if request.put?
      user = User.new
      user.email = params[:email]
      user.password_reset_key = params[:token]
      user.password = params[:password]

      if user.repassword
        redirect_with_success(signin_path, "password_reset.success")
      else
        fail_with("password_reset.no_token")
      end
    end
  end

  ## we will have to check this out later.
  def check_password(user, params)
    params.require(:email)
    user_params.each { |k, v| user.send("#{k}=", v) }

    if params.has_key?("current_password")
      user.password = params[:current_password]
      if user.find_by_email
        return true
      else
        return false
      end
    end
  end

  # Ha ! Ha !, a hack for accounts.show but a fancy name.
  # AJAX.
  def check_email
    params.require(:email)
    lower_email = Email.downcase(params[:email]).strip
    user = User.new

    EmailValidator.new(attributes: :email).validate_each(User.new, :email, lower_email)

    return redirect_with_failure(signup_path,'',user.errors.full_messages) if user.errors[:email].present?

    checker = EmailCheckerService.new
    email = params[:email]

    render json: checker.check_email(email)
  end


  # Log in the user
  def logon_after_password_reset
    log_on_user(@user)
    redirect_with_success(cockpits_path, 'password_reset.success')
  end

  def fail_with(key)
    redirect_with_failure(signin_path, key)
  end

  def user_params
    params.permit(:email, :password, :first_name, :last_name, :status)
  end

  private

  def fetch_user_from_params
    User.new
  end

end
