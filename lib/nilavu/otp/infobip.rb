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
module Nilavu
  module OTP
    class Infobip
      def initialize
        infobip_url = HTTP.persistent "https://api.infobip.com"
        @infobip = infobip_url.basic_auth(:user => "#{username}", :pass => "#{password}").headers(:json => {"Authorization" => "App #{api_key}"})
      end

      # Send pin to mibile
      def send_pin(mobile_number)
        pin_res = @infobip.post("/2fa/1/pin?ncNeeded=true", :json => {"applicationId" => "#{application_id}","messageId" => "#{message_id}","to" => "#{mobile_number}"})
        res_hash = JSON.parse("#{pin_res.body}")
        res_hash["smsStatus"] == "MESSAGE_SENT" ? "#{res_hash['pinId']}" : "Message sending failed"
      end

      # Verify pin
      def verify_pin(pin_id, pin)
        verify_res = @infobip.post("/2fa/1/pin/#{pin_id}/verify", :json => {
        "pin" => "#{pin}"})
        res_hash = JSON.parse("#{verify_res.body}")
        res_hash["verified"] ? true : false
      end

      # Send confirmation message
      def send_confirm(mobile_number, email)
        verify_res = @infobip.post("/sms/1/text/single", :json => {
          "from" => "MegamAfrica",
          "to" => "#{mobile_number}",
          "text" => "Hi #{email}, Thank you for signing up. All transaction details will be sent to this number."
        })
        true
      end

      private
      def username
        Ind.notification.infobip.username
      end

      def password
        Ind.notification.infobip.password
      end

      def api_key
        Ind.notification.infobip.api_key
      end

      def application_id
        Ind.notification.infobip.application_id
      end

      def message_id
        Ind.notification.infobip.message_id
      end
    end
  end
end
