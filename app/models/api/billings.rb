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

module Api
  class Billings < ApiDispatcher
    CURRENCY_USD = "USD".freeze
    CURRENCY_INR = "IN".freeze

    PAYMENT_PAYPAL   = "Pay with Paypal".freeze
    PAYMENT_COINKITE = "Pay with Coinkite".freeze

    def initialize()
    end

    def create(params)
      res = case
      when params["commit"] == PAYMENT_PAYPAL
        Paypal.generate_url(params)
      when params["commit"] == PAYMENT_COINKITE
        Coinkite.generate_url(params)
      end
      res
    end

    def execute(params)
      res = case
      when params["PayerID"]
        Paypal.execute(params)
      end
      res
    end

    def self.currencies
      [CURRENCY_USD,CURRENCY_INR]
    end
  end
end
