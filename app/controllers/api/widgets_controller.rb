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
  class WidgetsController < ApplicationController
    respond_to :json
    def index
      wid = [{"Widget id" => 1, "name" => "graph", "kind" => "datapoints", "size" => nil, "source" => "ganglia", "targets" => ["cpu_system"], "range" => "hour", "dashboard_id" => 1, "widget_type" => "pernode", "created_at" => nil, "updated_at" => nil}] if params["dashboard_id"] == "1"
      wid = [{"Widget id" => 1, "name" => "graph", "kind" => "containers", "size" => nil, "source" => "demo", "targets" => ["cpu_system"], "range" => "hour", "dashboard_id" => 2, "widget_type" => "percontainer", "created_at" => nil, "updated_at" => nil}] if params["dashboard_id"] == "2"
      respond_with(wid)
    end

  end
end
