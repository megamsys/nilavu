##
## Copyright [2013-2016] [Megam Systems]
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
require 'digest/sha1'
module Api
  class Accounts < APIDispatch
    extend Forwardable

    def_delegators :@auth_config, :id, :email, :password
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
      #verify_if_duplicate?(current_config(parms))
      @verify = false
      @auth_config = Nilavu::Auth::Configuration.from_hash(parms.merge({:api_key =>
      Nilavu::Auth::SignVerifier.hmackey}))
      api_request(ACCOUNT,SHOW,@auth_config.to_hash,"verify")
      verify_if_duplicate?(@verify)
      api_request(ACCOUNT, CREATE,@auth_config.to_hash)
      yield self if block_given?
      self
    end

    def authenticate(parms, &_block)
      #@auth_config = current_config({:email => parms[:email]})
      @auth_config = Nilavu::Auth::Configuration.from_hash(parms.merge({:email => parms[:email], :password => parms[:password]}))
      @auth_config = api_request(ACCOUNT,SHOW,@auth_config.to_hash, "verify")
      verify_if_notfound?
      @sign_verifier.authenticate(@auth_config[:body], parms[:password])
      yield self if block_given?
      self
    end

    def to_hash
      {
      :id =>  @id,
      :email =>  @email,
      :api_key =>  @api_key,
      :first_name =>  @first_name,
      :last_name =>  @last_name,
      :phone =>  @phone,
      :password =>  @password,
      :authority =>  @authority,
      :password_reset_key =>  @password_reset_key,
      :password_reset_sent_at =>  @password_reset_sent_at,
      :created_at =>  @created_at,
      :some_msg =>  @some_msg,
      :host =>  @host
      }
    end

    def list(params, &_block)
      @res = api_request(ACCOUNT, LIST, params)
      yield (@res.data[:body]) if block_given?
      @res.data[:body]
    end
    
    def show(params, &_block)
      raw = api_request(ACCOUNT, SHOW, params)
      yield (raw[:body]) if block_given?
      raw[:body]
    end

    def update(params, &_block)
      #Convert hash keys from symbol to string
      @auth_config = current_config(params).update_hash.stringify_keys
      #remove empty values from both the hases(params and auth_conf)
      param = params.reject{|_, v| v. nil? || v.empty?}
      @auth_config = @auth_config.reject{|_, v| v.blank?}
      #merge params and account data
      auth_hash = @auth_config.merge(param)
      #ACCOUNT UPDATE accepts only params data. So i do merge again auth_hash with params
      param = param.merge(auth_hash)
      param["password"] = Nilavu::Auth::SignVerifier.encrypt(params["password_confirmation"]) if params["password"]
      api_request(ACCOUNT, UPDATE, param)
      yield self if block_given?
      self
    end

    def reset(params, &block)
      @auth_config = current_config(params)
      update(@auth_config.to_hash.merge({:password_reset_key => Nilavu::Auth::SignVerifier.hmackey,
      :password_reset_sent_at => time_now }))
      @auth_config = current_config({:email => parms[:email]})
      yield self if block_given?
      self
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

    def current_config(params)
      Nilavu::Auth::Configuration.load(params[:email])
    end

    def verify_if_notfound?
      fail Api::Accounts::AccountNotFound, 'Au oh!, Hey you are new bloke, signup.' if @auth_config.nil?
    end

    def verify_if_duplicate?(copyof_auth_config)
      fail Api::Accounts::AccountFound, 'Au oh!, You are registered. Please signin.' if copyof_auth_config
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
