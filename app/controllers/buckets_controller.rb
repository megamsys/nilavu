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
## WITHOUT WARRANTIE  S OR CONDITIONS OF ANY KIND, either express or implied.
## See the License for the specific language governing permissions and
## limitations under the License.
##
require 'json'

class BucketsController < NilavuController
  respond_to :json, :js

  before_action :stick_ceph_keys, only: [:index, :create, :show, :upload, :destroy]

  def index
   if Backup::BackupUser.new.exists?(current_user.email)
    @bucket ||= Backup::Buckets.new(params).list
    @usage  ||= Backup::BackupUser.new.usage(current_user.email)
   else
    toast_warn(cockpits_path, "Storage account is not created. Ask support")
   end
  end

  def create
	begin
    Backup::Buckets.new(params).create(params[:id])
    @bucket ||= Backup::Buckets.new(params).list
    @msg = { message: "#{params['id']} created successfully.", bucket: @bucket, disposal_id: 'create_bucket', status: true }
	rescue Exception => e
    		@msg = { message: 'Bucket creation failed! Try different bucket name(more than 2 characters).', disposal_id: 'create_bucket', status: false }
	end
  end

  def show
    logger.debug '> Buckets: show.'
    #@objects = BucketObjects.new(params).list_detail
    #@bucket_name = params["id"]
  end

  def destroy
  end

end
