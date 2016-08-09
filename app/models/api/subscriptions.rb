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
    class Subscriptions < ApiDispatcher

        def where(params)
            raw = api_request(SUBSCRIPTIONS,SHOW, params)
            #        dig_subscriptions(raw[:body]) unless raw.nil?
            dig_subscriptions(params)
        end

        def save(params)
            api_request(SUBSCRIPTIONS, CREATE,params)
        end

        private

        def dig_subscriptions(rws)
            {   model: "ondemand",
                license: "trial",
                trial_ends: "21/11/2016 20:30:00",
            created_at:  '21/11/2016 20:30:00'}
        end
    end
end
