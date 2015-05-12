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
require 'net/smtp'

class ApplicationMailer < ActionMailer::Base
  default from: '#{Rails.configuration.support_email}' || 'support@megam.io'

  class MegamSnailError < StandardError; end

  # a common method that gets called by all the mailers.
  # every mailer needs to send a block to process.
  # errors are handled automatically
  def wrap_mail(tmp_params, &_block)
    if has_mail?
      begin
        @account  = tmp_params[:account]
        mail(to: @account.email, subject: tmp_params[:subject])
        yield if block_given?
      rescue Net::SMTPError => sme
        raise MegamSnailError, sme.message
      end
    end
  end

  def has_mail?
    "#{Rails.configuration.support_email}".chop!
  end
end
