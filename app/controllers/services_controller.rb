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
class ServicesController < ApplicationController
  respond_to :html, :js

  def index
    assem = Assemblies.new.list(params)
    assem.assemblies
    assem.apps_spun
    assem_vms_spun
    assem_services_spun
  end

  def new
  end

  def new_store
    @db_model = params[:db_model]
    @dbms = params[:dbms]
    @predef_name = params[:dbms]
    if"#{params[:deps_scm]}".strip.length != 0
      @deps_scm = "#{params[:deps_scm]}"
    elsif !"#{params[:scm]}".start_with?("select")
      @deps_scm = "#{params[:scm]}"
    end
    predef_options = { :predef_name => @predef_name}
    @predef_cloud = ListPredefClouds.perform(force_api[:email], force_api[:api_key])
    if @predef_cloud.class == Megam::Error
      redirect_to new_service_path, :gflash => { :warning => { :value => "#{@predef_cloud.some_msg[:msg]}", :sticky => false, :nodom_wrap => true } }
    else
      pred = FindPredefsByName.perform(predef_options,force_api[:email],force_api[:api_key])
      if pred.class == Megam::Error
        redirect_to new_service_path, :gflash => { :warning => { :value => "#{pred.some_msg[:msg]}", :sticky => false, :nodom_wrap => true } }
      else
        @predef = pred.lookup(@predef_name)
        @domain_name = ".megam.co"
        @no_of_instances=params[:no_of_instances]
      end
    end

  end

  def create
  end

end
