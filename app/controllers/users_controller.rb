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
class UsersController < ApplicationController
  respond_to :html, :js
  include UsersHelper
  include SessionsHelper

  #doesn't require a sign for new and create action, hence skip it.
  skip_before_action :require_signin, only: [:new, :create]

  #doesn't require to catch execption for show
  skip_around_action :catch_exception, only: [:show]

  #stick the api_keys before edit and update action
  before_action :stick_keys, only: [:edit, :update]

  #stick the host before create action
  before_action :stick_host, only: [:create]

  def show
  end

  def new
     if session[:auth]
      @social_uid = session[:auth][:uid]
      @email = session[:auth][:email]
      @firstname = session[:auth][:first_name]
      @lastname = session[:auth][:last_name]
      @phone = session[:auth][:phone]
      end
  end

  #This method is used to create a new user.
  #We create a Account for the user using /account call. A verification is done to check if the user is a dup.
  #Upon creating a new account, a session is created for the user and redirect to dash.
  def create
    logger.debug "> Users: create."
    all_params = params.merge(new_session)

	session[:tour]=true

    my_account = Accounts.new
    redirect_to signin_path, :flash => { :error => "Hey you!, I know you already."} and return if my_account.dup?(all_params[:email])

    my_account.create(all_params) do
      org_res = Organizations.new.list(all_params).orgs
      session[:org_id] = org_res[0][:id]
      sign_in my_account
	if "#{Ind.notification.email.password}" != ''
      UserMailer.welcome(my_account).deliver_now
	end
      redirect_to cockpits_path, :format => 'html', :flash => { :alert => "Welcome #{my_account.first_name}."}
     end
    storage_acc_res = Backup.account_create(params["email"])
	session[:storage_access_key] = storage_acc_res["access_key"]
	session[:storage_secret_key] = storage_acc_res["secret_key"]
  end

  #load the current user detail
  #load the current org details and send it the edit.html.erb.
  def edit
    logger.debug "> Users: edit."
    @account = current_user
    @orgs = Organizations.new.list(params).orgs
    @acc = Accounts.new.find_by_email(session[:email])

    @orgs
  end

  #update any profile information. First we verify if the current password matches with ours.
  #I don't know why we are creating a new_session here. This is a BUG.
  def update
    logger.debug "> Users: update"
    Accounts.new.update(params.merge({:remember_token => rem_tokgen})) do  |tmp_account|
        sign_in tmp_account
        @success = "#{Accounts.typenum_to_s(params[:myprofile_type])} updated successfully."
        @error = "Oops! Please contact support@megam.io"
    end  #if current_password_ok?    #removed it for now. does not work otherwise. need to come back.
    @msg = { title: "Profiles", message: "#{Accounts.typenum_to_s(params[:myprofile_type])} updated successfully!." , redirect: '/', disposal_id: 'app-1' }
   respond_to do |format|
     format.js {
       respond_with(@msg, @success, @error, :account => current_user, :api_key => current_user.api_key, :myprofile_type => params[:myprofile_type], :layout => !request.xhr? )
     }
   end
  end

  private

  #this verifies if the current password matches with the one typed during update.
  def current_password_ok?
    @error = nil
    case params[:myprofile_type].to_i
    when Accounts::UPD_PASSWORD
        begin
          Accounts.new.signin(params)
        rescue Accounts::AuthenticationFailure => ae
            @error   = ae.message
        end
    end
  end

end
