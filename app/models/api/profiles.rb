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
require 'json'
require 'bcrypt'

class Profiles < BaseAPIFascade
  include BCrypt


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
    @password_reset_token = nil
    @password_reset_sent_at = nil
  end


  def create(api_params,&block)
      final_options = {:first_name => api_params[:first_name], :last_name => api_params[:last_name],
                      :email => api_params[:email], :api_key => api_params[:api_key], :password => api_params[:password],
                       :password_confirmation => api_params[:password_confirmation], :password_reset_token => "" }
    @res = api_request(api_params,PROFILE, CREATE)
    yield (@res.data[:body]) if block_given?
    return @res.data[:body]
  end


  def list(api_params, &block)
    @res = api_request(api_params,ACCOUNT, LIST)
    yield (@res.data[:body]) if block_given?
    return @res.data[:body]
  end

  def dup?
    false
  end

  def update(columns, email)
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



  def find_by_email(email)
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

  def password_encrypt(password)
    Password.create(password)
  end

  def password_decrypt(pass)
    Password.new(pass)
  end

end
