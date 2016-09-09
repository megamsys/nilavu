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

class LaunchersController < ApplicationController

    respond_to :js

    before_action :add_authkeys_for_api, only: [:launch, :perform_launch]

    def launch
        @launch_item = HoneyPot.cached_marketplace_by_item(params)
        unless @launch_item
            render_with_error('marketplace.launch_item_load_failure')
        end

        respond_to do |format|
            format.js do
                respond_with(@launch_item, layout: !request.xhr?)
            end
        end
    end

    def perform_launch
        params.require(:mkp_name)
        params.require(:assemblyname)

        vertice = VerticeLauncher.new(LaunchingItem.new(params))
        if res = vertice.launch
            #  Scheduler::Defer.later "Log launch action for" do
            #    @nilavu_event_logger.log_launched(@launched)
            #  end
            render json: res
        else
          render failed_json # error is broken, we need to fix it.
        end
    end

end
