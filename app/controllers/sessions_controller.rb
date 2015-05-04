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
class SessionsController < ApplicationController
  include UsersHelper

  skip_before_action :require_signin, only: [:new, :tour, :create]


  def new
  end

  #this is a tour user who can only touch some stuff.
  def tour
      params[:email] =  Accounts::MEGAM_TOUR_EMAIL
      params[:password] =  Accounts::MEGAM_TOUR_PASSWORD
      create_with_megam(params)
  end

  #a regular user signin.
  def create
    auth = social_identity
    if social_identity.nil?
       create_with_megam(params)
    else
      create_social_identity(auth)
    end
  end

  def destroy
    sign_out
    redirect_to signin_path
  end

  def redirect_to_signup_with_fb
    fb = {:email => social_identity[:email], :first_name => social_identity[:name], :phone => social_identity[:phone], :last_name => social_identity[:last_name], :uid => social_identity[:uid]}
    redirect_to new_user_path
  end

  def redirect_to_dash(user)
    sign_in user
    redirect_to(cockpits_path, :gflash => { :success => { :value => "Welcome #{social_identity[:name]}. Your registered email is #{social_identity[:email]}, Thank you.", :sticky => false, :nodom_wrap => true } })
  end


private

  # verify if an omniauth.auth hash exists, if not consider it as a locally registered user.
  def social_identity
    auth = session[:auth]
  end

  def create_with_megam(all_params)
    my_account = Accounts.new
    begin
      my_account.signin(all_params) do
        sign_in my_account
        redirect_to cockpits_path, :notice => "Welcome #{my_account.first_name}."
      end
    rescue Accounts::AuthenticationFailure => ae
        redirect_to signin_path, :flash => { :error => ae.message}
    end
  end

  def create_social_identity(auth)
    @identity = Identity.new
    @iden = @identity.find_from_omniauth(auth)
    #Check for identity
    if @iden.nil?
      #No Megam Identity with current social identity
      user_identity = @user.find_by_email(social_identity[:email])
      if user_identity
        #If social user Already exists in megam
        if @identity.create_from_omniauth(auth, social_identity[:email])
          redirect_to_dash(user_identity)
        else
          logger.debug "==> Controller: users, Action: create, Something went wrong! User identity not saved"
          redirect_to signup_path
        end
      else
      #If social user don't exists in megam
        if @identity.create_from_omniauth(auth, social_identity[:email])
          redirect_to_signup_with_fb
        else
          logger.debug "==> Controller: users, Action: create, Something went wrong! User not saved"
          redirect_to signup_path
        end
      end
    elsif @user.find_by_email(social_identity[:email])
      #if user and identity already connected
      logger.debug "Found user with id #{social_identity[:email]}"
      user_identity = @user.find_by_email(social_identity[:email])
      redirect_to_dash(user_identity)
    else
    #Exception of all the above conditions
      redirect_to_signup_with_fb
    end
  end

end
