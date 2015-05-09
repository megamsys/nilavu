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
class OneservicesController < ApplicationController
  respond_to :html, :js
  before_action :stick_keys, only: [:index]


  def show
  end

  def index
    @assembly = Assembly.new.show(params.merge({"id" => params[:id]})).by_cattypes[Assemblies::DEW]
    @assembly
  end

  def show
  end

  def metrics
    serviceid = params["servicekey"]
    assembly=GetAssembly.perform(serviceid,force_api[:email],force_api[:api_key])
    if assembly.class != Megam::Error
      @appname = assembly.name + "." + assembly.components[0][0].inputs[:domain]
    else
      @appname = nil
    end
  end

  def logs
    @com_books = []
    @socketURL = Rails.configuration.socket_url
    appid = params["servicekey"]
    assembly=GetAssembly.perform(appid,force_api[:email],force_api[:api_key])
    if assembly.class != Megam::Error
      @appname = assembly.name + "." + assembly.components[0][0].inputs[:domain]
    else
      @appname = nil
    end
    assembly.components.each do |com|
      if com != nil
        com.each do |c|
          com_type = c.tosca_type.split(".")
          @com_books << c.name + "-" + com_type[2]
        end
      end
    end
  end

  def runtime
    serviceid = params["servicekey"]
    assembly=GetAssembly.perform(serviceid,force_api[:email],force_api[:api_key])
    if assembly.class != Megam::Error
      @appname = assembly.name + "." + assembly.components[0][0].inputs[:domain]
    else
      @appname = nil
    end
  end

  def services
    serviceid = params["servicekey"]
  end

  def lcservice
    @id = params[:id]
    @name = params[:name]
    @command = params[:command]
    respond_to do |format|
      format.js {
        respond_with(@id, @name, @command, :layout => !request.xhr? )
      }
    end
  end

end
