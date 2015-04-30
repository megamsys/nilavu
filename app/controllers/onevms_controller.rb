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
class OnevmsController < ApplicationController

  respond_to :html, :js
  include Packable
  include MarketplaceHelper


  def show

 end



  def overview
    if user_in_cookie?
      appid = params["appkey"]
      @assembly=GetAssembly.perform(appid,force_api[:email],force_api[:api_key])
    else
      redirect_to signin_path
    end
  end

def logs


end

end
