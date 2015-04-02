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
  def sign_in(user)
    cookies.permanent[:email] = user["email"]
    cookies.permanent[:remember_token] = user["remember_token"]
    self.current_user = user
  end

  def signed_in?
    !current_user.nil?
  end

  def current_user=(user)
    @current_user = user
  end

#  def current_user
 #   @current_user ||= User.find_by_remember_token(cookies[:remember_token], cookies[:email]) if cookies[:remember_token] && cookies[:email]
#  end

def sign_in_current_user(remember_token,email)

   @user = User.new
   res = @user.find_by_remember_token(remember_token,email) if remember_token && email
   if res != nil
     @current_user ||= res

    else
     redirect_to signin_path
    end

end

 def current_user

    @user = User.new
    res = @user.find_by_remember_token(cookies[:remember_token], cookies[:email]) if cookies[:remember_token] && cookies[:email]
    if res != nil
      @current_user ||= res

     else
      redirect_to signin_path
     end

 end

=begin
def riak_ping?
    begin
    client = Riak::Client.new(:nodes => [
      {:host => "#{Rails.configuration.storage_server_url}"}
    ])     
    true if "#{client.ping}" == "true"
    rescue Exception => se
	false
    end
  ret
end
=end

require 'open-uri'
def riak_ping?
  begin
    true if open("http://#{Rails.configuration.storage_server_url}:8098")
  rescue Exception => se
    false
  end
end

def api_ping?
  begin
    true if open("http://#{Rails.configuration.api_server_url}:9000")
  rescue
    false
  end
end


  def current_user_verify
   @user = User.new
    res = @user.find_by_remember_token(cookies[:remember_token], cookies[:email]) if cookies[:remember_token] && cookies[:email]
puts "CUrrent user verify============> "
puts res.inspect
    if res != nil
      @current_user ||= res
      return true
     else
       return false
     end
  end



  def current_user?(user)
    user == current_user
  end

  def signed_in_user
    unless signed_in?
      store_location
      redirect_to signin_path, notice: "Please sign in."
    end
  end

  def sign_out
    current_user = nil
    cookies.delete(:remember_token)
    cookies.delete(:email)
  end

  def redirect_back_or(default, growl_message)
    redirect_to((session[:return_to] || default), growl_message)
    session.delete(:return_to)
  end

  def store_location
    session[:return_to] = request.fullpath
  end

   def force_api(email=nil, api_token=nil)
    # dangerous. You are setting a global variable
    Megam::Log.level(Rails.configuration.log_level)
    email ||=current_user["email"]
    api_token ||=current_user["api_token"]
    logger.debug "--> force_api as email: #{email}, #{api_token}"
    {:email => email, :api_key => api_token }
  end

end
