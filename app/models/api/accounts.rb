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
module Api
  class Accounts < APIDispatch
    extend Forwardable

    def_delegators :@auth_config, :email, :password
    def_delegators :@auth_config, :api_key, :first_name
    def_delegators :@auth_config, :last_name, :verified
    def_delegators :@auth_config, :password_reset_key, :password_reset_sent_at, :created_at

    class  AccountNotFound < Nilavu::MegamGWError; end
    class  AccountFound < Nilavu::MegamGWError; end


    UPD_PROFILE         = 1
    UPD_PASSWORD        = 2
    UPD_API_KEY         = 3

    def initialize(parms = {})
      @sign_verifier = Nilavu::Auth::SignVerifier.new
      @auth_config   = Nilavu::Auth::Configuration.new
    end

    def create(parms, &_block)
      current_config(parms, true)
      @auth_config = Nilavu::Auth::Configuration.from_hash(parms.merge({:api_key =>
      Nilavu::Auth::SignVerifier.hmackey}))
      api_request(ACCOUNT, CREATE,@auth_config.to_hash)
      yield self if block_given?
      self
    end

    def authenticate(parms, &_block)
      @auth_config = current_config({:email => parms[:email]}, false)
      @sign_verifier.authenticate(@auth_config, parms[:password])
      yield self if block_given?
      self
    end

    def list(params, &_block)
      @res = api_request(ACCOUNT, LIST, params)
      yield (@res.data[:body]) if block_given?
      @res.data[:body]
    end

    def update(params, &_block)
      api_request(ACCOUNT, UPDATE, params)
      yield self if block_given?
      self
    end

    def reset(params, &block)
      update(current_config(params).to_hash.merge({:password_reset_key => Nilavu::Auth::SignVerifier.hmackey,
      :password_reset_sent_at => time_now }))
    end

    def find_by_password_reset_key(password_reset_key, email)
      @auth_config = current_config({:email => email})
      password_reset_key == "#{password_reset_key}"
      self
    end


    private
    def time_now
      "#{Time.zone.now}"
    end

    def current_config(params, skip_duplicate = true)
      auth_config = Nilavu::Auth::Configuration.load(params[:email])
      fail Api::Accounts::AccountNotFound, 'Au oh!, Hey you are new bloke, signup.' if auth_config.nil? && skip_duplicate
      fail Api::Accounts::AccountFound, 'Au oh!, You are registered. Please signin.' if auth_config && skip_duplicate
      auth_config
    end

    def self.typenum_to_s(updtype)
      case updtype.to_i
      when UPD_PROFILE
        return 'Profile '
      when UPD_PASSWORD
        return 'Password '
      when UPD_API_KEY
        return 'API key '
      end
    end
  end
end
