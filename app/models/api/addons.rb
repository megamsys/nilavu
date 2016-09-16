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
# this is a singleton which means we only load the marketplace once.
# the downside is if there is a change in marketplace then we need to restart nilavu.
module Api
    class Addons < ApiDispatcher

        attr_accessor :addon

        def initialize
          super(true)
        end

        def create(api_params)
         raw = api_request(ADDONS, CREATE, api_params)
         @addon = raw[:body] unless raw.nil?
         self
        end


        # This shows a single marketplace item. eg: 1-Ubuntu (Refer Marketplaces::list for more info)
        def show(api_params)
            raw = api_request(ADDONS, SHOW, api_params)
            @addon = raw[:body].first unless raw.nil?
            self
        end

        private

        def dig_addon(rwa)
            {   client_id: 'cloud@det.io',
                provider: 'whmcs',
            created_at:  '21/11/2016 20:30:00'}
        end
    end
end
