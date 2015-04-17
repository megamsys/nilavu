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
class UserMailer < ActionMailer::Base
  default from: "support@megam.co.in"
  def welcome_email(user)
    logger.debug "user = #{user}"
    @user = user
    #@random_token = user.verification_hash
    #@url  = "https://www.megam.co/verified_email.#{@random_token}"
    mail(:to => user["email"], :subject => "Megam Account Confirmation")
  end

  def password_reset(user)
    @user = user
    mail :to => user["email"], :subject => "Reset your Megam Password"
  end

  
  def error_email(error)
    logger.debug "error #{error[:email]} = #{error[:message]}"
    @error = error
    mail(:from => error[:email], :to => "support@megam.co.in", :subject => "#{@error[:email]} :www.megam.co, got #{@error[:message]}")
  end

end
