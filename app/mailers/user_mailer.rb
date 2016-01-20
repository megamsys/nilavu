##
## Copyright [2013-2016] [Megam Systems]
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
    wrap_mail({:account =>  account, :subject => 'Ahoy There, Welcome Aboard!' })
  end

  def reset(account)
    wrap_mail(:account => account, subject: 'You have fat fingers. No worries.')
  end


  def invite(account, org_id)
    @org_id = org_id
    wrap_mail(:account => account, subject: 'Invitation to Party!')
  end

  def verify
    # @url  = "https://console.megam.io/verified_email.#{@random_token}"
  end

  def balance
  end
end
