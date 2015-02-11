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
  end


  def send_welcome_email(cookies)
    test = sign_in_current_user(cookies[:remember_token], cookies[:email])
    UserMailer.welcome_email(test).deliver
  end

  def generate_token
    SecureRandom.urlsafe_base64
  end

  def builder(options)
    hash = {
      "first_name" => options["first_name"],
      "last_name" => options["last_name"],
      "admin" => true,
      "phone" => options["phone"],
      "onboarded_api" => false,
      "user_type" => options["user_type"],
      "email" => options["email"],
      "api_token" => "",
      "password" => password_encrypt(options["password"]),
      "password_confirmation" => password_encrypt(options["password_confirmation"]),
      "verified_email" => false,
      "verification_hash" => options["verification_hash"],
      "created_at" => Time.zone.now,
      "updated_at" => Time.zone.now,
      "password_reset_token" => "",
      "password_reset_sent_at" => "",
      "remember_token" => options["remember_token"],
      "org_id" => ""
    }

    hash.to_json
  end

  def save(options)
    hash = builder(options)
    result = true
    res_body = MegamRiak.upload("profile", options[:email], hash, "application/json")
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

end
