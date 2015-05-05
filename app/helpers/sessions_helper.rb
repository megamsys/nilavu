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
module SessionsHelper

  #create a new session
  def new_session
    session.delete(:auth)
    session.delete(:email)
    session.delete(:api_key)
    session_params = {}
    session_params[:remember_token] = rem_tokgen
    session_params[:api_key] = api_keygen
    logger.debug "> newsession #{session_params}"
    session_params
  end
  
  
  def new_remtokgn
    
    
    session_params = {}
    session_params[:remember_token] = rem_tokgen
    session_params
  end

  #a cache to store the sign details of an user in a cookie jar using keys
  #email and remember_token
  def sign_in(account)
    cookies.permanent[:email] = account.email
    cookies.permanent[:remember_token] = account.remember_token || rem_tokgen
    logger.debug "> signin session email #{session[:email]}"
    logger.debug "> signin session api   #{session[:api_key]}"
    session[:email] = account.email
    session[:api_key] = account.api_key
    logger.debug "> signin psession email #{session[:email]}"
    logger.debug "> signin psession api   #{session[:api_key]}"
    self.current_user = account
  end

  #return if an user is signed in or not. ?
  def signed_in?
    session[:email] && session[:api_key]
  end


 #return an account object from session which has the email and api key.
 def current_user
  unless signed_in?
    logger.debug "> Hmm. session Nada! I loaded current_user."
    res = Accounts.new.find_by_email(cookies[:email])  if  cookies[:remember_token] && cookies[:email]
  else
    Accounts.new(session)
  end
 end

 def current_user=(account)
   @current_user = account
 end

 #signout the current user by nuking current_user value as nil
 #and delete the remembered cookies.
 def sign_out
   current_user = nil
   cookies.delete(:remember_token)
   cookies.delete(:email)
   session.delete(:email)
   session.delete(:api_key)
 end

end
