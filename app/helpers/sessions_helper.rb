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
module SessionsHelper
  # The signed_in? method simply returns true if the user is logged
  # in and false otherwise. It does this by "booleanizing" the
  # current_user method we created previously using a double ! operator.
  def signed_in?
    !!current_user
  end

  # Finds the User with the email, api_key stored in the session with the key
  # :cemail, :api_key This is a common way to handle user login in
  def current_user
    @_current_user ||= (session[:email] && session[:api_key]) &&  Nilavu::Auth::Configuration.load(session[:email])
  end

  def cleanup_session
    [:email, :api_key, :org, :environment, :return_to].each { |n| session.delete(n) }
    @_current_user = session[:email] = nil
  end

  # Store the URI of the current request in the session.
  #
  # We can return to this location by calling #redirect_back_or_default.
  def store_location
    session[:return_to] = request.url
  end

  # Store the email and api_key of the current user in the session.
  def store_credentials(acct)
    session[:email] = acct.email
    session[:api_key] = acct.api_key
  end

  # Store the cephgw storage access_key and secret_key
  def store_ceph_credentials(ceph)
    session[:ceph_access_key] = ceph['access_key']
    session[:ceph_secret_key] = ceph['secret_key']
  end

  # Redirect to the URI stored by the most recent store_location call or
  # to the passed default.
  def redirect_back_or_default(default)
    loc = session[:return_to] || default
    session[:return_to] = nil
    redirect_to loc
  end

  def loaded_environments?
   session[:org]
  end

  private

  def save_oauth(oauth)
    session[:auth] = { :email => oauth[:email], :first_name => oauth[:first_name], :last_name => oauth[:last_name] }
  end
end
