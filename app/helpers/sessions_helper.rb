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

  #a cache to store the sign details of an user in a cookie jar using keys
  #email and remember_token
  def sign_in(user)
    cookies.permanent[:email] = user["email"]
    cookies.permanent[:remember_token] = user["remember_token"]
    self.current_user = user
  end

  #return if an user is signed in or not. ?
  def signed_in?
    !current_user.nil?
  end


 #return the current_user object by looking at the  remembertoken, email from cookie jar or
 #redirect to the sign page.
 def current_user
    @user = User.new
    res = @user.find_by_remember_token(cookies[:remember_token], cookies[:email]) if cookies[:remember_token] && cookies[:email]
    if res != nil
      @current_user ||= res
     else
      redirect_to signin_path
     end
 end

 #a setter for the current user in the class variable currernt_user.
 def current_user=(user)
   @current_user = user
 end

 #signout the current user by nuking current_user value as nil
 #and delete the remembered cookies.
 def sign_out
   current_user = nil
   cookies.delete(:remember_token)
   cookies.delete(:email)
 end

 #this method merely forces a setter for the api worker. Before calling the api worker, its
 #needed to call this force_api
 def force_api(email=nil, api_token=nil)
  # dangerous. You are setting a global variable
  Megam::Log.level(Rails.configuration.log_level)
  email ||=current_user["email"]
  api_token ||=current_user["api_token"]
  logger.debug "--> force_api as email: #{email}, #{api_token}"
  {:email => email, :api_key => api_token }
 end

require 'open-uri'

##we need to know if our gateway (api server) is running. this is a friendly ping.
def api_ping?
  begin
    true if open("http://#{Rails.configuration.api_server_url}:9000")
  rescue
    false
  end
end

#we need to know riak is working, for nilavu to work reliably. Just a ping check.
#probably move it to a API call like status in the future.
def riak_ping?
  begin
    true if open("http://#{Rails.configuration.storage_server_url}:8098")
  rescue Exception => se
    false
  end
end



end
