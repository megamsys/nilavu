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

=begin
  def show
    @user = User.find(params[:id])
    current_user = @user
  end

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
  #After a successful save : redirect to users dashboard.
  #1. create a  new session, upon creating a profile, save the session and create an account.
  #2.If the user already exists then redirect to signin.
  def create
    logger.debug "--> Users:create."
    params = params.merge(new_session)
    logger.debug "--> params \n #{params}"

    prof = api.Profiles.new

    redirect_to signin_path, :flash => { :warning => "Hey #{@user.first_name}, I know you already."} and return if prof.dup(params[:email])

    prof.create(params) do
      sign_in prof
      UserMailer.welcome(prof).deliver_now
      redirect_to main_dashboards_path, :format => 'html', :flash => { :alert => "Welcome #{params[:first_name]}."}
     end
  end

  def edit
    if user_in_cookie?
      logger.debug "--> Users:edit, user in cookie."
      @user = User.new
      logger.debug "==> Controller: users, Action: edit, Start edit"
      @orgs = list_organizations
      @userdata= @user.find_by_email(current_user["email"])
      @userdata
    else
      redirect_to signin_path
    end
  end

  def update
    if user_in_cookie?
      logger.debug "==> Controller: users, Action: update, Update user pw, api_key"
      @user = User.new
      @userdata = @user.find_by_email(current_user["email"])
      @user_fields_form_type = params[:user_fields_form_type]
      if @user_fields_form_type == 'api_key'
        logger.debug "User update For API key"
        api_token = api_keygen
        options = { :id => "", :email => current_user["email"], :api_key => api_token, :authority => "admin" }
        @res_body = CreateAccounts.perform(options)
        if !(@res_body.class == Megam::Error)
          update_options = { "onboarded_api" => true, "api_token" => api_token, "updated_at" => Time.zone.now }
          res_update = @user.update_columns(update_options, current_user["email"])
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
            respond_with(@res_msg, @err_msg, :user => current_user, :api_token => current_user["api_token"], :user_fields_form_type => params[:user_fields_form_type], :layout => !request.xhr? )
          }
        end
      elsif @user_fields_form_type == 'profile'
        update_options = { "first_name" => params[:first_name], "phone" => params[:phone] }
        res_update = @user.update_columns(update_options, current_user["email"])
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
            respond_with(@res_msg, @err_msg, :user => current_user, :api_token => current_user["api_token"], :user_fields_form_type => params[:user_fields_form_type], :layout => !request.xhr? )
          }
        end
      elsif @user_fields_form_type == 'password'
        if @user.password_decrypt(@userdata["password"]) == params[:current_password]
          if params[:password] == params[:password_confirmation]
            update_options = { "password" => @user.password_encrypt(params[:password]), "password_confirmation" => @user.password_encrypt(params[:password_confirmation]) }
            res_update = @user.update_columns(update_options, current_user["email"])
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
                respond_with(@res_msg, @err_msg, :user => current_user, :api_token => current_user["api_token"], :user_fields_form_type => params[:user_fields_form_type], :layout => !request.xhr? )
              }
            end
          else
            @res_msg = nil
            @err_msg = "Password update: The password's are doesn't match. Please re-enter the correct password."
            respond_to do |format|
              format.js {
                respond_with(@res_msg, @err_msg, :user => current_user, :api_token => current_user["api_token"], :user_fields_form_type => params[:user_fields_form_type], :layout => !request.xhr? )
              }
            end
          end
        else
          @res_msg = nil
          @err_msg = "Password update: The current password is wrong. Please re-enter the correct password."
          respond_to do |format|
            format.js {
              respond_with(@res_msg, @err_msg, :user => current_user, :api_token => current_user["api_token"], :user_fields_form_type => params[:user_fields_form_type], :layout => !request.xhr? )
            }
          end
        end
      end
    else
      redirect_to signin_path
    end
  end

  def list_organizations
    if user_in_cookie?
      logger.debug "--> #{self.class} : list organizations entry"
      org_collection = ListOrganizations.perform(force_api[:email], force_api[:api_key])
      orgs = []
      if org_collection.class != Megam::Error
        org_collection.each do |one_org|
          orgs << {:name => one_org.name, :created_at => one_org.created_at.to_time.to_formatted_s(:rfc822)}
        end
        orgs = orgs.sort_by {|vn| vn[:created_at]}
      end
    orgs
    else
      redirect_to signin_path
    end
  end
end
