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
    class Billingtransactions < ApiDispatcher

        attr_reader :transactions

        def initialize
            @transactions = []
            super(true) # swallow 404 errors for assemblies.
        end


        def list(params, &_block)
            raw = api_request(BILLINGTRANSACTIONS, LIST, params)
            #        dig_transactions(raw[:body]) unless raw.nil?
            dig_transactions(params)
            yield self  if block_given?
            self
        end

        def dig_transactions(rwa)
            @transactions = [{
                accounts_id: 'cloud@det.io',
                gateway: 'paypal',
                amountin: '10',
                amountout: '10.99',
                fees: '0.99',
                tranid: 'KXY00X1',
                trandate: '21/11/2016',
                currency_type: '$',
            created_at:  '21/11/2016 20:30:00'}]
        end
    end
end
