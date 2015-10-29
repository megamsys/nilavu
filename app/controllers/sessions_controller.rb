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
class SessionsController < NilavuController
  skip_before_action :require_signin, only: [:new, :tour, :create]

  def new
  end

  def create
    authenticate(params)
  end

  # this is a fake tour user who can only touch some stuff.
  def tour
    authenticate({:email => Nilavu::Constants::MEGAM_TOUR_EMAIL,
    :password => Nilavu::Constants::MEGAM_TOUR_PASSWORD })
  end

  def destroy
    cleanup_session
    toast_info(signin_path, "Have fun.")
  end

  private
  def authenticate(params)
    Api::Accounts.new.authenticate(params) do |acct|
      store_credentials acct
      puts "--------------------------"
      toast_success(cockpits_path, "Get started. marketplace awaits..")
    end
  rescue Api::Accounts::AccountNotFound => an
    toast_error(signup_path, an.message)
  rescue Nilavu::Auth::SignVerifier::PasswordMissmatchFailure => ae
    toast_error(signin_path, ae.message)
  rescue Api::Accounts::IKnowYou => ae
    toast_error(signin_path,ae.message)
    # for other errors do we have to aise error  back or it gets handled automatically by applicable_controller
  end
end
