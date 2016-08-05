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

class CockpitsController < ApplicationController
    include CockpitListResponder

    respond_to :html, :js

    skip_before_filter :check_xhr

    before_action :add_authkeys_for_api, only: [:all, :torpedo, :app, :service, :microservices]

    def entrance
        render 'cockpits/entrance'  #unless current_user && hasVeto

    #    redirect_to 'users/subcription'
    end

    def all
        params[:filter] = Api::Assemblies::ALL
        respond_with_list(Api::Assemblies.new.list(params).baked.flatten)
    end

    def torpedo
        params[:filter] = Api::Assemblies::TORPEDO
        respond_with_list(Api::Assemblies.new.list(params).baked.flatten)
    end

    def app
        params[:filter] = Api::Assemblies::APP
        respond_with_list(Api::Assemblies.new.list(params).baked.flatten)
    end

    def service
        params[:filter] = Api::Assemblies::SERVICE
        respond_with_list(Api::Assemblies.new.list(params).baked.flatten)
    end

    def microservices
        params[:filter] = Api::Assemblies::MICROSERVICES
        respond_with_list(Api::Assemblies.new.list(params).baked.flatten)
    end
end
