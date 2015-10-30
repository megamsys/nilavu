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

require 'bcrypt'

class SessionsController < ApplicationController
  include UsersHelper
  include BCrypt

  skip_before_action :require_signin, only: [:new, :tour, :create]

  def new
  end

  # this is a tour user who can only touch some stuff.
  def tour
    params[:email] =  Accounts::MEGAM_TOUR_EMAIL
    params[:password] = Accounts::MEGAM_TOUR_PASSWORD
    create_with_megam(params)
  end

  # a regular user signin.
  def create
      create_with_megam(params)

  end

  def callbacks # it wont even enter here...will be redirected from :require_signin

   end

  def destroy
    sign_out
    redirect_to signin_path
  end

  def create_social
  create_social_identity(params)
end

  def create_social_identity(social_identity)
    acct = Accounts.new
    det = acct.find_by_email(social_identity[:email])
    if !det.email.nil?
      params[:email] = det.email
      params[:password] = det.password

      acct.signin_identity(params) do
        sign_in acct
        redirect_to cockpits_path, notice: "Welcome #{acct.first_name}."
      end
    else
      redirect_to new_user_path
     end
  end



  # verify if an omniauth.auth hash exists, if not consider it as a locally registered user.
  def social_identity
    auth = session[:auth]
    auth
  end

  def password_decrypt(pass)
    Password.new(pass)
   rescue BCrypt::Errors::InvalidHash
     Rails.logger.debug "> Couldn't decrpt password. Its possible that the password in gateway was just text."
     raise AuthenticationFailure, 'Au oh!, The password you entered is incorrect.'
   end

  def create_with_megam(all_params)
    my_account = Accounts.new

    begin
      my_account.signin(all_params) do
        puts my_account.inspect
        sign_in my_account
        redirect_to cockpits_path, notice: "Welcome #{my_account.first_name}."
      end
    rescue Accounts::AuthenticationFailure => ae
      redirect_to signin_path, flash: { error: ae.message }
    end
  end
end
