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
#class User < ActiveRecord::Base
require 'json'
require 'bcrypt'

class User
  include BCrypt
  include SessionsHelper
  def initialize()
    @first_name = nil
    @last_name = nil
    @admin = true
    @phone = nil
    @onboarded_api = false
    @user_type = nil
    @email = nil
    @api_token = nil
    @password = nil
    @password_confirmation = nil
    @verified_email = false
    @verification_hash = nil
    @app_attributes = nil
    @cloud_identity_attributes = nil
    @apps_item_attributes = nil
    @password_reset_token = nil
    @password_reset_sent_at = nil
  end


  def generate_token
    SecureRandom.urlsafe_base64
  end

  def builder(options)
    hash = {
      "first_name" => options["first_name"],
      "last_name" => options["last_name"],
      "admin" => options["admin"],
      "phone" => options["phone"],
      "onboarded_api" => options["onboarded_api"],
      "user_type" => options["user_type"],
      "email" => options["email"],
      "api_token" => options["api_token"],
      "password" => password_encrypt(options["password"]),
      "password_confirmation" => password_encrypt(options["password_confirmation"]),
      "verified_email" => options["verified_email"],
      "verification_hash" => options["verification_hash"],
      "created_at" => Time.zone.now,
      "updated_at" => Time.zone.now,
      "password_reset_token" => options["password_reset_token"],
      "password_reset_sent_at" => options["password_reset_sent_at"],
      "remember_token" => options["remember_token"],
      "org_id" => options["org_id"]
    }

    hash.to_json
  end

  def save(options, api_token)
    hash = builder(options)
    result = true
    #res_body = MegamRiak.upload("profile", options[:email], hash, "application/json")
    res_body = CreateProfile.perform(options, options[:email], api_token)
    if res_body.class == Megam::Error
    result = false
    end
    result
  end

  def update_columns(columns, email)
    result = true
    res = MegamRiak.fetch("profile", email)
    res.content.data.map { |p|
      if columns["#{p[0]}"].present?
        res.content.data["#{p[0]}"] = columns["#{p[0]}"]
      end
    }
    res_body = MegamRiak.upload("profile", email, res.content.data.to_json, "application/json")
    if res_body.class == Megam::Error
    result = false
    end
    result
  end

  def find_by_remember_token(remember_token, email)
    result = nil
    res = MegamRiak.fetch("profile", email)
    if res.class != Megam::Error
    result = res.content.data
    end
    result
  end

  def find_by_password_reset_token(password_reset_token, email)
    result = nil
    res = MegamRiak.fetch("profile", email)
    if (res.class != Megam::Error) && (res.content.data["password_reset_token"] == "#{password_reset_token}")
    result = res.content.data
    end
    result
  end


  def find_by_email(email)
    result = nil
    res = MegamRiak.fetch("profile", email)
    if res.class != Megam::Error
    result = res.content.data
    end
    result
  end

  def password_encrypt(password)
    Password.create(password)
  end

  def password_decrypt(pass)
    Password.new(pass)
  end

  def send_password_reset(email)
	   @user = User.new
	    update_options = { "password_reset_sent_at" => "#{Time.zone.now}", "password_reset_token" => generate_token }
      res_update = @user.update_columns(update_options, email)
	    user = @user.find_by_email(email)
      if res_update
        UserMailer.password_reset(user).deliver_now
      else
        puts "API Key update: Something went wrong! User not updated"
      end
    end

end
