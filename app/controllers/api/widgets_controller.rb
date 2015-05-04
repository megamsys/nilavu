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
    def show
      widget = Widget.for_dashboard(params[:dashboard_id]).find(params[:id])
      respond_with(widget)
    end

    def index
      wid = [{"Widget id" => 1, "name" => "graph", "kind" => "datapoints", "size" => nil, "source" => "ganglia", "targets" => ["cpu_system"], "range" => "hour", "dashboard_id" => 1, "widget_type" => "pernode", "created_at" => nil, "updated_at" => nil}]
      respond_with(wid)
    end

    def create
      logger.debug ("> api.widgets: create")
      dashboard = Dashboard.find(params[:dashboard_id])
      input = JSON.parse(request.body.read.to_s)
      widget = dashboard.widgets.build(Widget.slice_attributes(input))
      if widget.save
        render :json => widget, :status => :created, :location => api_dashboard_widget_url(:dashboard_id => dashboard.id, :id => widget.id)
      else
        render :json => widget.errors, :status => :unprocessable_entity
      end
    end

    def update
      logger.debug ("> api.widgets: update")
      dashboard = Dashboard.find(params[:dashboard_id])
      widget = dashboard.widgets.find(params[:id])
      input = JSON.parse(request.body.read.to_s)
      if widget.update_attributes(Widget.slice_attributes(input))
        head :no_content
      else
        render :json => widget.errors, :status => :unprocessable_entity
      end
    end

    def destroy
      dashboard = Dashboard.find(params[:dashboard_id])
      widget = dashboard.widgets.find(params[:id])
      widget.destroy
      head :no_content
    end

  end
end
