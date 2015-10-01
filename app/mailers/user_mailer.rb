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
class UserMailer < ApplicationMailer
  # an welcome email gets formatted to be sent
  def welcome(account)
    wrap_mail({:account =>  account, :subject => 'Hey, Launch your first app' }) do
      Rails.logger.debug "> Welcome email:[#{account.email}] delivered. "
    end
  end

  def reset(account)
    wrap_mail(:account => account, subject: 'You have fat fingers. No worries.') do
      Rails.logger.debug "Reset email:[#{account.email}]."
    end
  end


  def invite(account, org_id)
    @org_id = org_id
    wrap_mail(:account => account, subject: 'You have been invited!!.') do
      Rails.logger.debug "Invite email:[#{account.email}]."
    end
  end

  def verify
    # @url  = "https://console.megam.io/verified_email.#{@random_token}"
  end

  def balance
  end

end
