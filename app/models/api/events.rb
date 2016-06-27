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
            #raw = api_request(EVENTS, LIST, api_params)
            #baked(raw[:body])
            mock = rand(1..7)
            case mock
            when 1
                success_stub_1
            when 2
                success_stub_2
            when 3
                success_stub_3
            when 4
                success_stub_1
            when 5
                success_stub_4
            when 6
            #    error_stub_3
                []
            when 7
                []
            end
        end

        private

        def success_stub_1
            s = []
            s << std(LAUNCHING, "Your  machine is initializing..")
            s << std(LAUNCHED, "Machine  was initialized on cloud..")
        end

        def success_stub_2
            s = []
            s << std(BOOTSTRAPPED, "machine was booted..")
            s << std(STATEUP, "moving up in the state for machine")
            s << std(CHEFRUNNING, "chef was running on your machine")
        end

        def success_stub_3
            s = []
            s << std(COOKBOOKSUCCESS, "chef cookbooks are successfully downloaded..")
            s << std(IPUPDATED, "IP updated for your machine")
            s << std(AUTHKEYSADDED, "Access keys are updated in machine")
            s << std(ROUTEADDED, "A DNS route added for machine")
        end

        def success_stub_4
            s = []
            s << std(RUNNING, "SUCCESS ! - machine is running..")
        end

        def error_stub_3
            s = []
            s << std(ERROR, "oops something went wrong on your machine")
        end

        def std(evt_type, desc)
            {
                id: 'NTF' + rand(100...1000).to_s,
                event_type: evt_type,
                account_id: "",
                assembly_id: "ASM00001",
                data: [{key: :desc, value: desc}, {key: :read, value: false}],
                created_at: Time.now + 10
            }
        end

    end
end
