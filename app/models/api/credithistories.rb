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
module Api
  class Credithistories < APIDispatch
    attr_reader :bill_type
    attr_reader :credit_amount
    attr_reader :currency_type
    
    def initialize()
      @balance = {}
    end

    def create(params, amount, &block)
      api_request(CREDITHISTORIES, CREATE, params.merge(bld_chistories(amount)))
      yield self if block_given?
      return self
    end

    def bld_chistories(amount)
      {
        :bill_type => "paypal",
        :credit_amount =>  amount,
        :currency_type => "USD"
      }
    end
  end
end
