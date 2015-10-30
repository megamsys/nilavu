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

  before_action :stick_ceph_keys, only: [:index, :create, :destroy, :show]

  def index
    bucketobj = Backup::BucketObjects.new(params)
    respond_with(bucketobj.list)
  end

  def create
    bucketobjs = Backup::BucketObjects.new(params)
    bucketobjs.create(params[:sobject])
    @msg = { title: 'Storage', message: "#{params[:sobject].original_filename} uploaded successfully. ", redirect: '/', disposal_id: 'supload' }
  end

  def show
    @objects = Backup::BucketObjects.new(params).list_detail
    respond_with(@objects)
  end
  def destroy
    BucketObjects.new(params).delete(bucket_name)
  end
end
