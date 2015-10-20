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

class BucketkolkesController < ApplicationController
  respond_to :json, :js

  before_action :stick_storage_keys, only: [:index, :create, :show, :upload]

  def index
    logger.debug '>Controller index called'
    new_backup = Backup.new("#{session[:storage_access_key]}", "#{session[:storage_secret_key]}", Ind.backup.host)
    data = new_backup.buckets_list
    respond_with(data)
  end

  def Create
  end

  def upload
    backup = Backup.new(params[:accesskey], params[:secretkey], Ind.backup.host)
    backup.object_create("#{params[:bucket_name]}", params[:sobject])
    @msg = { title: 'Storage', message: "#{params[:sobject].original_filename} uploaded successfully. ", redirect: '/', disposal_id: 'supload' }
  end

  def destroy
    logger.debug '> Bucketskolkes: delete'
    backup = Backup.new(params[:accesskey], params[:secretkey], Ind.backup.host)
    backup.bucket_delete(bucket_name)
  end

  # sign our request by Base64 encoding the policy document.
  def upload_signature
    request = S3::Object.temporary_url(expiretemps_at = Time.now + 3600)
    signature = S3::Signature.generate(host: Ind.backup.host, request: request, access_key_id: params[:accesskey], secret_access_key: params[:secretkey])
  end
end
