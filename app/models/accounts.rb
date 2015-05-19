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
require 'json'

class Accounts < BaseFascade
  include BCrypt
  attr_reader :email
  attr_reader :password
  attr_reader :api_key
  attr_reader :first_name
  attr_reader :phone
  attr_reader :remember_token
  attr_reader :password_reset_key
  attr_reader :created_at

  ACCOUNTS_BUCKET     = "accounts".freeze
  ADMIN               = 'admin'.freeze
  MEGAM_TOUR_EMAIL    = 'tour@megam.io'.freeze
  MEGAM_TOUR_PASSWORD = 'faketour'.freeze

  UPD_PROFILE         = 1.freeze
  UPD_PASSWORD        = 2.freeze
  UPD_API_KEY         = 3.freeze


  def initialize(account_parms={})
    @first_name            = account_parms[:first_name] || nil
    @last_name             = account_parms[:secon_name] || nil
    @phone                 = account_parms[:phone] || nil
    @email                 = account_parms[:email] || nil
    @api_key               = account_parms[:api_key] || nil
    @password              = account_parms[:password] || nil
    @password_confirmation = account_parms[:pasword_confirmation] || nil
    @authority             = nil
    @remember_token        = nil
    @verified_email        = false
    @verification_hash     = nil
    @password_reset_token  = nil
    @created_at            = account_parms[:created_at] || nil
  end


  #verifies if the email is a duplicate.
  def dup?(email)
   !find_by_email(email).email.nil?
  end

  #pulls the account object for an email
  def find_by_email(email)
    storage = Storage.new(ACCOUNTS_BUCKET).fetch(email)
    if !storage.content.data.nil?
      @email = storage.content.data["email"]
      @password = storage.content.data["password"]
      @api_key = storage.content.data["api_key"]
      @first_name = storage.content.data["first_name"]
      @phone = storage.content.data["phone"]
      @password_reset_key = storage.content.data["password_reset_key"]
      @created_at = storage.content.data["created_at"]
   end
   return self
  end

  #performs a siginin check, to see if the passwords match.
  def signin(api_params, &block)
    raise   AuthenticationFailure, "Au oh!, The email or password you entered is incorrect." if find_by_email(api_params[:email]).nil?

    unless password_decrypt(password) == api_params[:password]
       raise   AuthenticationFailure, "Au oh!, The email or password you entered is incorrect."
    end
    yield self if block_given?
    return self
  end

  #creates a new account
  def create(api_params,&block)
    Rails.logger.debug "> Accounts: create"
    api_request(bld_acct(api_params), ACCOUNT, CREATE)
    @remember_token = api_params[:remember_token]
    @api_key = api_params[:api_key]
    @email = api_params[:email]
    @first_name = api_params[:first_name]
    @phone = api_params[:phone]
    @api_key = api_params[:api_key]
    yield self if block_given?
    return self
  end

  #updates an account based on the input params sent.
  def update(api_params,&block)
    api_request(bld_acct(api_params), ACCOUNT, UPDATE)
    @remember_token = api_params[:remember_token] if api_params[:remember_token]
    @email = api_params[:email] if api_params[:email]
    @first_name = api_params[:first_name] if api_params[:first_name]
    @phone = api_params[:phone] if api_params[:phone]
    @api_key = api_params[:api_key] if api_params[:api_key]
    @password_reset_key = api_params[:password_reset_key] if api_params[:password_reset_key]
    yield self if block_given?
    return self
  end


  def list(api_params, &block)
    @res = api_request(api_params, ACCOUNT, LIST)
    yield (@res.data[:body]) if block_given?
    return @res.data[:body]
  end

  def find_by_password_reset_key(password_reset_key, email)
    find_by_email
    @password_reset_key == "#{password_reset_key}"
  end

  #a private helper function that builds the hash.
  private
  def bld_acct(api_params)
    acct_parms = {
     :id => nil,
     :first_name => api_params[:first_name],
     :last_name => api_params[:last_name],
     :phone => api_params[:phone],
     :email => api_params[:email],
     :api_key => api_params[:api_key],
     :password => password_encrypt(api_params[:password]),
     :authority => ADMIN,
     :password_reset_key => api_params[:password_reset_key],
     :password_reset_sent_at => api_params[:password_reset_sent_at],
     :created_at => api_params[:created_at]}
  end




  def password_encrypt(password)
    Password.create(password)
  end

  def password_decrypt(pass)
    begin
      Password.new(pass)
    rescue BCrypt::Errors::InvalidHash
      Rails.logger.debug "> Couldn't decrpt password. Its possible that the password in gateway was just text."
      raise   AuthenticationFailure, "Au oh!, The password you entered is incorrect."
    end
  end

  def self.typenum_to_s(updtype)
    case updtype.to_i
    when UPD_PROFILE
      return "Profile "
    when UPD_PASSWORD
      return "Password "
    when UPD_API_KEY
      return "API key "
  end
end

end
