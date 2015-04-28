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
  include SessionsHelper


  attr_reader :email
  attr_reader :password
  attr_reader :api_key
  attr_reader :first_name
  attr_reader :phone
  attr_reader :remember_token
  attr_reader :created_at

  ADMIN   = 'admin'.freeze
  MEGAM_TOUR_EMAIL="tour@megam.io".freeze
  MEGAM_TOUR_PASSWORD="faketour".freeze

  def initialize()
    @first_name = nil
    @last_name = nil
    @phone = nil
    @email = nil
    @api_key = nil
    @password = nil
    @password_confirmation = nil
    @authorization = nil
    @remember_token = nil
    @authority = nil
    @verified_email = false
    @verification_hash = nil
    @password_reset_token = nil
    @created_at = nil
  end

  #verifies if the email is a duplicate.
  def dup?(email)
   !find_by_email(email).email.nil?
  end

  #pulls the account object for an email
  def find_by_email(email)
    res = MegamRiak.fetch("accounts", email)
    if res.class != Megam::Error && !res.content.data.nil?
      @email = res.content.data["email"]
      @password = res.content.data["password"]
      @api_key = res.content.data["api_key"]
      @first_name = res.content.data["first_name"]
      @phone = res.content.data["phone"]
      @created_at = res.content.data["create_at"]
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
    self
  end

  #creates a new account object.
  def create(api_params,&block)
    acct_parms = {:first_name => api_params[:first_name], :last_name => api_params[:last_name],
                    :phone => api_params[:phone], :email => api_params[:email],
                    :api_key => api_params[:api_key], :password => password_encrypt(api_params[:password]),
                    :authority => ADMIN, :password_reset_token => "" }

    api_request(acct_parms, ACCOUNT, CREATE)
    @remember_token = api_params[:remember_token]
    @email = api_params[:email]
    @first_name = api_params[:first_name]
    @phone = api_parms[:phone]

    yield self if block_given?
    return self
  end


  def list(api_params, &block)
    @res = api_request(api_params, ACCOUNT, LIST)
    yield (@res.data[:body]) if block_given?
    return @res.data[:body]
  end


  def update(columns, email)
    result = true
    res = MegamRiak.fetch("profile", email)
    res.content.data.map { |p|
      if columns["#{p[0]}"].present?
        res.content.data["#{p[0]}"] = columns["#{p[0]}"]
      end
    }
    res_body = MegamRiak.upload("accounts", email, res.content.data.to_json, "application/json")
    if res_body.class == Megam::Error
    result = false
    end
    result
  end


  def find_by_password_reset_token(password_reset_token, email)
    result = nil
    res = MegamRiak.fetch("accounts", email)
    if (res.class != Megam::Error) && (res.content.data["password_reset_token"] == "#{password_reset_token}")
    result = res.content.data
    end
    result
  end

  def send_password_reset(email)
    @user = User.new
    update_options = { "password_reset_sent_at" => "#{Time.zone.now}", "password_reset_token" => generate_token }
    res_update = @user.update_columns(update_options, email)
    user = @user.find_by_email(email)
    if res_update
      UserMailer.password_reset(user).deliver_now
    else
      puts "API update: Something went wrong!"
    end
  end

  private

  def password_encrypt(password)
    Password.create(password)
  end

  def password_decrypt(pass)
    begin
      Password.new(pass)
    rescue BCrypt::Errors::InvalidHash
      Rails.logger.debug "--> Couldn't decrpt your password. Its possible that the saved account password in gateway was just text."
      raise   AuthenticationFailure, "Au oh!, The password you entered is incorrect."
    end
  end

end
