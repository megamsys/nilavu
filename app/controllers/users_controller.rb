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
  skip_before_action :require_signin, only: [:new, :create]

  include UsersHelper
  include SessionsHelper


  def show
    #@user = User.find(params[:id])
    #current_user = @user
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
      UserMailer.welcome(my_account).deliver_now
      redirect_to main_dashboards_path, :format => 'html', :flash => { :alert => "Welcome #{my_account.first_name}."}
     end
  end

  #load the current user detail
  #load the current org details and send it the edit.html.erb.
  def edit
    logger.debug "--> Users:edit."
    @account = current_user
    Organizations.new.list(@account) do |my_org|
      @orgs = my_org
    end
  end

  def update
    logger.debug "--> Users:update."
      @user = User.new
      @userdata = @user.find_by_email(current_user.email)
      @user_fields_form_type = params[:user_fields_form_type]
      if @user_fields_form_type == 'api_key'
        logger.debug "User update For API key"
        api_token = api_keygen
        options = { :id => "", :email => current_user.email, :api_key => api_token, :authority => "admin" }
        @res_body = CreateAccounts.perform(options)
        if !(@res_body.class == Megam::Error)
          update_options = { "onboarded_api" => true, "api_token" => api_token, "updated_at" => Time.zone.now }
          res_update = @user.update_columns(update_options, current_user.email)
          if res_update
            sign_in @userdata
            @res_msg = "API Key updated successfully"
            @err_msg = nil
          else
            @res_msg = nil
            @err_msg = "API Key update: Something went wrong! User not updated"
          end
        else
          @res_msg = nil
          @err_msg = "#{@res_body.some_msg[:msg]}"
        end
        respond_to do |format|
          format.js {
            respond_with(@res_msg, @err_msg, :user => current_user, :api_token => current_user.api_key, :user_fields_form_type => params[:user_fields_form_type], :layout => !request.xhr? )
          }
        end
      elsif @user_fields_form_type == 'profile'
        update_options = { "first_name" => params[:first_name], "phone" => params[:phone] }
        res_update = @user.update_columns(update_options, current_user.email)
        if res_update
          sign_in @userdata
          @res_msg = "Profile updated successfully"
          @err_msg = nil
        else
          @res_msg = nil
          @err_msg = "Profile update: Something went wrong! User not updated"
        end
        respond_to do |format|
          format.js {
            respond_with(@res_msg, @err_msg, :user => current_user, :api_token => current_user.api_key, :user_fields_form_type => params[:user_fields_form_type], :layout => !request.xhr? )
          }
        end
      elsif @user_fields_form_type == 'password'
        if @user.password_decrypt(@userdata["password"]) == params[:current_password]
          if params[:password] == params[:password_confirmation]
            update_options = { "password" => @user.password_encrypt(params[:password]), "password_confirmation" => @user.password_encrypt(params[:password_confirmation]) }
            res_update = @user.update_columns(update_options, current_user.email)
            if res_update
              sign_in @userdata
              @res_msg = "Password updated successfully"
              @err_msg = nil
            else
              @err_msg = "Password update: Something went wrong! User not updated"
              @res_msg = nil
            end
            respond_to do |format|
              format.js {
                respond_with(@res_msg, @err_msg, :user => current_user, :api_token => current_user.api_key, :user_fields_form_type => params[:user_fields_form_type], :layout => !request.xhr? )
              }
            end
          else
            @res_msg = nil
            @err_msg = "Password update: The password's are doesn't match. Please re-enter the correct password."
            respond_to do |format|
              format.js {
                respond_with(@res_msg, @err_msg, :user => current_user, :api_token => current_user.api_key, :user_fields_form_type => params[:user_fields_form_type], :layout => !request.xhr? )
              }
            end
          end
        else
          @res_msg = nil
          @err_msg = "Password update: The current password is wrong. Please re-enter the correct password."
          respond_to do |format|
            format.js {
              respond_with(@res_msg, @err_msg, :user => current_user, :api_token => current_user.api_key, :user_fields_form_type => params[:user_fields_form_type], :layout => !request.xhr? )
            }
          end
        end
      end
  end


end
