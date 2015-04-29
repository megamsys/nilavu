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
    session_params = {}
    session_params[:remember_token] = rem_tokgen
    session_params[:api_key] = api_keygen
    session_params
  end

  #a cache to store the sign details of an user in a cookie jar using keys
  #email and remember_token
  def sign_in(account)
    cookies.permanent[:email] = account.email
    cookies.permanent[:remember_token] = account.remember_token || rem_tokgen
    self.current_user = account
  end

  #return if an user is signed in or not. ?
  def signed_in?
    !current_user.nil?
  end

  #return true if the user is in the cookie, used by the pre handler in application controller
  # require_signin
  def user_in_cookie?
    res = Accounts.new.find_by_email(cookies[:email]) if cookies[:remember_token] && cookies[:email]
    if res!=nil
      logger.debug "--> sessionHelper: user_in_cookie? ${(res !=nil)}"
    end
    res != nil
  end

 #return the current_user object by looking at the  remembertoken, email from cookie jar or
 #redirect to the sign page.
 def current_user
   logger.debug "--> sessionHelper: current_user"
   res = Accounts.new.find_by_email(cookies[:email]) if  cookies[:remember_token] && cookies[:email]
   if res!=nil
      @current_user ||= res
   else
    redirect_to signin_path
   end
 end


 def current_user=(account)
   @current_user = account
 end


 def force_api(email=nil, api_token=nil)
  Megam::Log.level(Rails.configuration.log_level)
  Rails.logger.debug("--> sessionsHelper: force_api ")
  email ||=current_user.email
  api_key ||=current_user.api_key
  {:email => email, :api_key => api_key }
 end



 #signout the current user by nuking current_user value as nil
 #and delete the remembered cookies.
 def sign_out
   current_user = nil
   cookies.delete(:remember_token)
   cookies.delete(:email)
 end

end
