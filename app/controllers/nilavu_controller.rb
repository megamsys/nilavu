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
class NilavuController < ApplicationController
  before_action :require_signin

  # load environments if we are signed in
  before_filter {|controller| load_environments if signed_in? && !loaded_environments?}


  #############################################################################
  # Filters
  #############################################################################
  #1 if something needs a signin add it.
  def require_signin
    unless signed_in?
      self.store_location
      redirect_to signin_path
    end
  end
  #2 if something needs a registration add it. (eg: oauth)
  def require_registration
    unless signed_in?
      if request.fullpath.to_s.match('auth')
        stick_auth_keys
        redirect_to signup_path
      end
    end
  end

  def stick_keys(_tmp = {}, _permitted_tmp = {})
    logger.debug "> STICKM"
    params.merge!(Hash[%w(email api_key org_id).map {|x| [x, session[x.to_sym]]}])
  end

  def stick_ceph_keys(_tmp = {}, _permitted_tmp = {})
    logger.debug "> STICKC"
    params.merge!(Hash[%w(ceph_access_key ceph_secret_key).map {|x| [x, session[x.to_sym]]}])
    end

  def stick_auth_keys()
    auth = request.env['omniauth.auth']['extra']['raw_info']
    session[:auth] = { email: auth[:email], first_name: auth[:first_name], last_name: auth[:last_name] }
  end
  #############################################################################
  # Enviroment setting needed for an user (org, backup)
  #############################################################################
  def load_environments
    load_organizations(current_user)
    load_ceph(current_user) if Ind.backup.enable
  end

  def load_organizations(current_user)
    session[:org_id] = Api::Organizations.new.list(current_user.to_hash).first
  end

  def load_ceph(current_user)
    res = Backup::BackupUser.new.create(current_user.email, current_user.id)
    store_ceph_credentials(res)
  end
end
