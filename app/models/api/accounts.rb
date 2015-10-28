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
require 'bcrypt'

module Api
  class Accounts < APIDispatch
    include BCrypt

    BUCKET              = 'accounts'.freeze
    ADMIN               = 'admin'.freeze
    MEGAM_TOUR_EMAIL    = 'tour@megam.io'.freeze
    MEGAM_TOUR_PASSWORD = 'faketour'.freeze
    UPD_PROFILE         = 1
    UPD_PASSWORD        = 2
    UPD_API_KEY         = 3

    class  AccountNotFound < Nilavu::MegamGWError; end
    class  PasswordMissmatchFailure < Nilavu::MegamGWError; end
    class  InvalidPasswordFailure < Nilavu::MegamGWError; end
    class  IKnowYou < Nilavu::MegamGWError; end


    def initialize(parms = {})
      email parms[:email]
      api_key parms[:api_key]
      first_name parms[:first_name]
      last_name parms[:last_name]
      password parms[:password]
      phone parms[:phone]
      authority parms[:authority]
      password_reset_key parms[:password_reset_key]
      password_reset_sent_at parms[:password_reset_sent_at]
      verified parms[:verified]
    end

    def email(arg=nil)
      if arg != nil
        @email = arg
      else
        @email
      end
    end

    def api_key(arg=nil)
      if arg != nil
        @api_key = arg
      else
        @api_key
      end
    end

    def first_name(arg=nil)
      if arg != nil
        @first_name = arg
      else
        @first_name
      end
    end

    def last_name(arg=nil)
      if arg != nil
        @last_name = arg
      else
        @last_name
      end
    end

    def password(arg=nil)
      if arg != nil
        @password = arg
      else
        @password
      end
    end

    def phone(arg=nil)
      if arg != nil
        @phone = arg
      else
        @phone
      end
    end

    def authority(arg=nil)
      if arg != nil
        @authority = arg
      else
        @authority
      end
    end

    def verified(arg=nil)
      if arg != nil
        @verified = arg
      else
        @verified
      end
    end

    def password_reset_key(arg=nil)
      if arg != nil
        @password_reset_key = arg
      else
        @password_reset_key
      end
    end

    def password_reset_sent_at(arg=nil)
      if arg != nil
        @password_reset_sent_at = arg
      else
        @password_reset_sent_at
      end
    end

    def created_at(arg=nil)
      if arg != nil
        @created_at = arg
      else
        @created_at
      end
    end

    def create(parms, &_block)
      fail Api::Accounts::IKnowYou, 'Au oh!, You are registered. Please signin.' unless Api::Accounts.load(parms[:email]).nil?
      act = Api::Accounts.from_hash(parms.merge({:api_key => api_keygen}))
      api_request(ACCOUNT, CREATE,act.to_hash)
      yield act if block_given?
      self
    end

    def authenticate(params, &_block)
      tmp = account_for(params)
      unless password_decrypt(account_for(params).password) == params[:password]
        fail Api::Accounts::PasswordMissmatchFailure, 'Au oh!, The email or password you entered is incorrect.'
      end
      yield tmp if block_given?
      tmp
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
      update(account_for(params).to_hash.merge({:password_reset_key => api_keygen,
      :password_reset_sent_at => time_now }))
    end

    def find_by_password_reset_key(password_reset_key, email)
      act = Api::Accounts.load(email)
      act.password_reset_key == "#{password_reset_key}"
      act
    end

    def self.from_hash(act_hash)
      act_hash = Hash[act_hash.map{|(k,v)| [k.to_sym,v]}]
      act = Api::Accounts.new(act_hash)
      act
    end

    def to_hash
      { :email => @email,
        :api_key => @api_key,
        :password => password_encrypt(@password),
        :first_name => @first_name,
        :last_name => @last_name,
        :phone => @phone,
        :authority => ADMIN,
        :password_reset_key => @password_reset_key,
        :password_reset_sent_at => @password_reset_sent_at,
        :created_at => @created_at,
      :verified => @verified  }
    end

    def self.load(email)
      riak = Nilavu::DB::GSRiak.new(BUCKET).fetch(email)
      unless riak.content.data.nil?
        return Api::Accounts.from_hash(riak.content.data)
      end
    end

    private
    def time_now
      "#{Time.zone.now}"
    end

    def api_keygen
      p SecureRandom.urlsafe_base64(nil, true)
    end

    def password_encrypt(password)
      Password.create(password)
    end

    def password_decrypt(pass)
      Password.new(pass)
    rescue BCrypt::Errors::InvalidHash
      raise Api::Accounts::InvalidPasswordFailure, 'Au oh!, The password you entered is incorrect.'
    end

    def account_for(params)
      act = Api::Accounts.load(params[:email])
      if act.nil?
        fail Api::Accounts::AccountNotFound, 'Au oh!, Hey you are new bloke, signup.'
      end
      act
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
