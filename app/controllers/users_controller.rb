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

  # doesn't require a sign for new and create action, hence skip it.
  skip_before_action :require_signin, only: [:new, :create]

  # doesn't require to catch execption for show
  skip_around_action :catch_exception, only: [:show]

  # stick the api_keys before edit and update action
  before_action :stick_keys, only: [:edit, :update]

  # stick the host before create action
  before_action :stick_host, only: [:create]

  def show
  end

  def new
    if session[:auth]
      @social_uid = session[:auth][:uid]
      @email = session[:auth][:email]

     end
  end

  # This method is used to create a new user.
  # We create a Account for the user using /account call. A verification is done to check if the user is a dup.
  # Upon creating a new account, a session is created for the user and redirect to dash.
  def create
    logger.debug '> Users: create.'
    all_params = params.merge(new_session)

    session[:tour] = true

    my_account = Accounts.new
    redirect_to(signin_path, flash: { toastr: 'Hey you!, I know you already. Please Signin.' }) && return if my_account.dup?(all_params[:email])

    my_account.create(all_params) do
     org_res = Organizations.new.list(all_params).orgs
    session[:org_id] = org_res[0][:id]

      sign_in my_account
      if "#{Ind.notification.email.password}" != ''
        UserMailer.welcome(my_account).deliver_now
      end
      redirect_to cockpits_path, format: 'html', flash: { alert: "Welcome #{my_account.first_name}." }
    end

    if Ind.backup.enable
	backup_client = BackupUser.new(Ind.backup.host, Ind.backup.username, Ind.backup.password)
    storage_acc_res = backup_client.create(params['email'],'displayname_accountid')
    session[:storage_access_key] = storage_acc_res['access_key']
    session[:storage_secret_key] = storage_acc_res['secret_key']
  end
end

  # load the current user detail
  # load the current org details and send it the edit.html.erb.
  def edit
    logger.debug '> Users: edit.'
    @account = current_user
    @orgs = Organizations.new.list(params).orgs
    @acc = Accounts.new.find_by_email(session[:email])
    @orgs
  end

  # update any profile information. First we verify if the current password matches with ours.
  # I don't know why we are creating a new_session here. This is a BUG.
  def update
    logger.debug '> Users: update'
    Accounts.new.update(params.merge(remember_token: rem_tokgen)) do |tmp_account|
      sign_in tmp_account
      @success = "#{Accounts.typenum_to_s(params[:myprofile_type])} updated successfully."
      @error = 'Oops! Please contact support@megam.io'
    end # if current_password_ok?    #removed it for now. does not work otherwise. need to come back.
    @msg = { title: 'Profiles', message: "#{Accounts.typenum_to_s(params[:myprofile_type])} updated successfully!.", redirect: '/', disposal_id: 'app-1' }
    respond_to do |format|
      format.js do
        respond_with(@msg, @success, @error, account: current_user, api_key: current_user.api_key, myprofile_type: params[:myprofile_type], layout: !request.xhr?)
      end
    end
  end

  def invite
    logger.debug '> Users: Organization invite'
    if params[:email] != session[:email]
      acct = Accounts.new.find_by_email(params[:email])
      UserMailer.invite(acct, session[:org_id]).deliver_now
      @msg = { title: 'Organization Invite', message: "#{params['email']} invited successfully. ", redirect: '/', disposal_id: 'invite_user' }

    else
      @msg = { title: 'Organization Invite', message: "#{params['email']} is your own email! You cannot invite yourself into your own organization", redirect: '/', disposal_id: 'invite_user' }

  end
  end

  # NOTE: get the invitees default org_id to add the params[org_id] into the invitee's default org bucket
  # as related organizations. U1 invited U2, so params contains U2 email and U1 orgId.
  # get org_id with email
  # update org
  def organization_invite
    params['host'] = Ind.http_api
    params['api_key'] = Accounts.new.find_by_email(params['email']).api_key

    org_res = Organizations.new.list(params).orgs

    org_res[0][:related_orgs] << params['org_id']
    org_res[0][:api_key] = params['api_key']
    org_res[0][:email] = params['email']
    org_res[0][:host] = Ind.http_api

    res = Organizations.new.update(org_res[0])
    redirect_to root_url
  end

  private

  # this verifies if the current password matches with the one typed during update.
  def current_password_ok?
    @error = nil
    case params[:myprofile_type].to_i
    when Accounts::UPD_PASSWORD
      begin
        Accounts.new.signin(params)
      rescue Accounts::AuthenticationFailure => ae
        @error = ae.message
      end
    end
  end
end
