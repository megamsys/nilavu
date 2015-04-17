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
class VisualisationsController < ApplicationController
  before_filter :require_login

  def show
    #@containers = !cookies[:donabe_ip].nil?
    respond_to do |format|
      format.html
    end
  end

  private

  def require_login
    session[:current_user_id] ||= cookies[:current_user_id]
    session[:current_token] ||= cookies[:current_token]

    unless logged_in?
      flash[:error] = "Please login to access designer!"
      redirect_to login_url
    end
  end

end
