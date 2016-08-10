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
class Infobip

  API = 'https://api.infobip.com'

  # Send pin to mibile
  def self.send_pin_to(mobile_number)
    begin
      client = ensure_client_is_available
      response = client.post("/2fa/1/pin?ncNeeded=true", :json => for_message_id(mobile_number))
      Results.new(response, mobile_number)
    rescue StandardError => se
      #{:error => "Oops, the application tried to load a URL that doesn't exist."}
      false
    end
  end

  # Verify pin
  def self.verify_pin(pin_id, pin, mobile_number)
    client = ensure_client_is_available

    response = client.post("/2fa/1/pin/#{pin_id}/verify", :json => {"pin" => "#{pin}"})

    Results.new(response, mobile_number)
  end

  # Send confirmation message
  def self.confirmation_message(mobile_number, email)
    client = ensure_client_is_available

    response = client.post("/sms/1/text/single", :json => MultiJson.dump(
      :from => UrlHelper.public_suffix(SiteSetting.contact_url),
      :to => mobile_number,
      :text => t('signup.otp_verified', email: email)))

    Results.new(response.body)
  end

  private

  def self.ensure_client_is_available
    return client if client

    raise Nilavu::NotFound
  end

  def self.client
    h = HTTP.persistent API

    h.basic_auth(:user => "#{username}", :pass => "#{password}").headers(:json => {"Authorization" => "App #{api_key}"})
  end

  def self.for_message_id(mobile_number)
    {"applicationId" => application_id, "messageId" => message_id, "to" => mobile_number}
  end

  def self.username
    SiteSetting.infobip_username
  end

  def self.password
    SiteSetting.infobip_password
  end

  def self.api_key
    SiteSetting.infobip_api_key
  end

  def self.application_id
    SiteSetting.infobip_application_id
  end

  def self.message_id
    SiteSetting.infobip_message_id
  end
end
