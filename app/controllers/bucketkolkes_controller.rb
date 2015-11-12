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
## WITHOUT WARRANTIE  S OR CONDITIONS OF ANY KIND, either express or implied.
## See the License for the specific language governing permissions and
## limitations under the License.
##
require 'json'

class BucketkolkesController < NilavuController
  respond_to :json, :js

  before_action :stick_ceph_keys, only: [:index, :create, :show, :upload, :destroy]

  def index
    respond_with(Backup::BucketObjects.new(params).list)
  end

  def create
    params[:id] = params[:bucket_name]
    Backup::BucketObjects.new(params).create(params[:sobject])
    @msg = { message: "#{params[:sobject].original_filename} uploaded successfully. ", disposal_id: 'onebucket_upload' }
  end

  def show
    @objects = Backup::BucketObjects.new(params).detail
    @bucket_name = params[:id]
    respond_with(@objects)
  end

  def destroy
    #object_name = params[:id].split("/").last
    #bucket_name = params[:id].split("/").first
    Backup::BucketObjects.new(params).delete(bucket_name)
    @bobjs = []
    respond_to do |format|
      format.js do
        respond_with(@bobjs, layout: !request.xhr?)
      end
    end
  end
end
