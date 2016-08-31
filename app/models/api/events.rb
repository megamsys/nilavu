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
    class Events < ApiDispatcher

        LAUNCHING       = 'LAUNCHING'.freeze
        LAUNCHED        = 'LAUNCHED'.freeze
        BOOTSTRAPPED    = 'BOOTSTRAPPED'.freeze
        STATEUP         = 'STATEUP'.freeze
        CHEFRUNNING     = 'CHEFRUNNING'.freeze
        COOKBOOKSUCCESS = 'COOKBOOKSUCCESS'.freeze
        IPUPDATED       = 'IPUPDATED'.freeze
        AUTHKEYSADDED   = 'AUTHKEYSADDED'.freeze
        ROUTEADDED      = 'ROUTEADDED'.freeze
        RUNNING         = 'RUNNING'.freeze
        ERROR           = 'ERROR'.freeze

        def initialize
            super(true) # swallow 404 errors for assemblies.
        end

        def recent(api_params, &_block)
            raw = api_request(EVENTS, LIST, api_params)
            baked(raw[:body])
        end

    end
end
