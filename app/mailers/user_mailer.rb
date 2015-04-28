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
  default from: "support@megam.io"

  def welcome(account)
    #@url  = "https://console.megam.io/verified_email.#{@random_token}"
    if "#{Rails.configuration.support_email}".chop!
      begin
         mail(:to => account.email, :subject => "Hey, Launch your first app")
      rescue Net::SMTPAuthenticationError, Net::SMTPServerBusy, Net::SMTPSyntaxError, Net::SMTPFatalError, Net::SMTPUnknownError => e
        logger.debug "--> Failed to send a welcome email for #{account.email}."
      end
    end
  end

  def password_reset(account)
    if "#{Rails.configuration.support_email}".chop!
      begin
         mail :to => account.email, :subject => "You have fat fingers. No worries."
      rescue Net::SMTPAuthenticationError, Net::SMTPServerBusy, Net::SMTPSyntaxError, Net::SMTPFatalError, Net::SMTPUnknownError => e
        logger.debug "--> Failed to send a password reset email for #{account.email}."
      end
    end
  end


  def error_email(error)
    @error = error
    mail(:from => error[:email], :to => "support@megam.io", :subject => "#{error[:email]} :console.megam.io, #{error[:message]}")
  end

end
