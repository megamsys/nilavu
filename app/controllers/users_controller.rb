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


  def show
  end

=begin
  def new
    logger.debug "--> Users:new, creating new user with social identity."
    if session[:auth]
      @user = User.new
      @social_uid = session[:auth][:uid]
      @email = session[:auth][:email]
      @firstname = session[:auth][:first_name]
      @lastname = session[:auth][:last_name]
      @phone = session[:auth][:phone]
    end
  end
=end

  #This method is used to create a new user.
  #We create a Account for the user using /account call. A verification is done to check if the user is a dup.
  #Upon creating a new account, a session is created for the user and redirect to dash.
  def create
    logger.debug "--> Users:create."
    all_params = params.merge(new_session)
    logger.debug "-->  allparams \n #{all_params}"

    my_account = Accounts.new
    redirect_to signin_path, :flash => { :error => "Hey you!, I know you already."} and return if my_account.dup?(all_params[:email])

    my_account.create(all_params) do
      sign_in my_account
      #UserMailer.welcome(my_account).deliver_now
      redirect_to main_dashboards_path, :format => 'html', :flash => { :alert => "Welcome #{my_account.first_name}."}
     end
  end

  #load the current user detail
  #load the current org details and send it the edit.html.erb.
  def edit
    logger.debug "--> Users:edit."
    @account = current_user
    @orgs = Organizations.new.list(@account).orgs 
      
   
  end

  #update any profile information. Interms of passwor we verify if the current password matches with ours.
  def update
    logger.debug "--> Users:update."
    
    my_account = Accounts.new
    case params[:myprofile_type].to_i
    when Accounts::UPD_PASSWORD
        begin
          my_account.signin(params) do
          end
        rescue Accounts::AuthenticationFailure => ae
            @error   = ae.message
        end
    end
    (Accounts.new.update(params.merge(new_session)) do  |tmp_account|
        sign_in tmp_account
        @success = "#{params[:user_fields_form_type]} updated successfully."

        @error = nil
    end)   if @error.nil?
   respond_to do |format|
     format.js {
       respond_with(@success, @errror, :account => current_user, :api_key => current_user.api_key, :myprofile_type => params[:myprofile_type], :layout => !request.xhr? )
     }
   end
  end
end
